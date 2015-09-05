class FantasyTeam < ActiveRecord::Base
	has_many :draft_picks
	has_many :nfl_players, through: :draft_picks
	belongs_to :league

	validates :owner, 
		uniqueness: {
			scope: :league_id, 
			message: 'has already been taken. Every owner must have a unique name for this league.'
		}, 
		presence: true

	def self.from_owner(owner, league)
		where(league: league).where('lower(owner) = ?', owner.downcase).first
	end

	def roster
		# roster_class = "FantasyTeam::#{league.roster_style.titleize}Roster".constantize
		Roster.build(league.roster_info(:starters), draft_picks)
	end

	def at_limit?(pos, players = nil)
		players ||= nfl_players.where(position: pos)
		limit = league.roster_info(:limits)[pos]
		players.count	>= limit
	end

	def picks_left
		league.roster_size - nfl_players.count
	end

	def has_minimum?(pos, players = nil)
		players ||= nfl_players.where(position: pos)
		min = league.roster_info(:minimums)[pos]
		players.count	>= min
	end

	def absolute_position_needs
		players = nfl_players.all.to_a
		needs = NflPlayer::VALID_POSITIONS.select do |pos| 
			!has_minimum?(pos, players.select {|player| player.position == pos })
		end
		if needs.map {|pos| league.roster_info(:minimums)[pos] }.reduce(:+) == picks_left
			needs
		else
			[]
		end
	end

	def limited_positions
		if absolute_position_needs.count > 0
			return NflPlayer::VALID_POSITIONS.select {|pos| !absolute_position_needs.include?(pos) }
		end

		players = nfl_players.all.to_a
		NflPlayer::VALID_POSITIONS.select do |pos| 
			at_limit?(pos, players.select {|player| player.position == pos })
		end
	end

end
