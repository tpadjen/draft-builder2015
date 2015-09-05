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

	def at_limit?(pos, players = nil)
		players ||= nfl_players.where(position: pos)
		limit = ROSTER_INFO[league.roster_style.to_sym][:limits][pos]
		players.count	>= limit
	end

	def limited_positions
		players = nfl_players.all.to_a
		NflPlayer::VALID_POSITIONS.select do |pos| 
			at_limit?(pos, players.select {|player| player.position == pos })
		end
	end

end
