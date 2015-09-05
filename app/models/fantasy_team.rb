class FantasyTeam < ActiveRecord::Base
	has_many :draft_picks
	has_many :nfl_players, through: :draft_picks
	belongs_to :league

	ROSTER_INFO = {
		hymm: {
			size: 16,
			starters: {
				'QB' 		=>  1,
				'RB' 		=>  1,
				'WR' 		=>  2,
				'FLEX|RB|WR' =>  1,
				'TE'    =>  1,
				'DEF'   =>  1,
				'K'     =>  1
			},
			limits: {
				'QB' 		=>  9,
				'RB' 		=>  10,
				'WR' 		=>  11,
				'TE'    =>  9,
				'DEF'   =>  9,
				'K'     =>  9
			},
			minimums: {
				'QB' 		=>  1,
				'RB' 		=>  2,
				'WR' 		=>  2,
				'TE'    =>  1,
				'DEF'   =>  1,
				'K'     =>  1
			}
		},
		beavers: {
			size: 16,
			starters: {
				'QB' 	=>  1,
				'RB' 	=>  2,
				'WR' 	=>  2,
				'TE' 	=>  1,
				'DEF' =>  1,
				'K' 	=>  1
			},
			limits: {
				'QB' 		=>  2,
				'RB' 		=>  3,
				'WR' 		=>  3,
				'TE'    =>  2,
				'DEF'   =>  2,
				'K'     =>  2
			},
			minimums: {
				'QB' 		=>  2,
				'RB' 		=>  3,
				'WR' 		=>  3,
				'TE'    =>  2,
				'DEF'   =>  2,
				'K'     =>  2
			}
		}
	}

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
		Roster.build(ROSTER_INFO[league.roster_style.to_sym][:starters], draft_picks)
	end

	def roster_info
		ROSTER_INFO[league.roster_style.to_sym]
	end

	def at_limit?(pos, players = nil)
		players ||= nfl_players.where(position: pos)
		limit = roster_info[:limits][pos]
		players.count	>= limit
	end

	def picks_left
		roster_info[:size] - nfl_players.count
	end

	def has_minimum?(pos, players = nil)
		players ||= nfl_players.where(position: pos)
		min = roster_info[:minimums][pos]
		players.count	>= min
	end

	def absolute_position_needs
		players = nfl_players.all.to_a
		needs = NflPlayer::VALID_POSITIONS.select do |pos| 
			!has_minimum?(pos, players.select {|player| player.position == pos })
		end
		if needs.map {|pos| roster_info[:minimums][pos] }.reduce(:+) == picks_left
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
