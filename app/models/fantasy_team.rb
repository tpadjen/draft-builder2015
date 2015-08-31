class FantasyTeam < ActiveRecord::Base
	has_many :draft_picks
	has_one :league
	has_many :nfl_players, through: :draft_picks

	validates :owner, 
		uniqueness: {
			scope: :league_id, 
			message: 'has already been taken. Every owner must have a unique name for this league.'
		}, 
		presence: true

	def self.from_owner(owner)
		where('lower(owner) = ?', owner.downcase).first
	end

	def roster
		picks = draft_picks.includes(nfl_player: :nfl_team).order(:number)
		selected = picks.selected

		starters = {}
		bench = {
			'QB' => [],
			'RB' => [],
			'WR' => [],
			'TE' => [],
			'DEF' => [],
			'K' => []
		}

		selected.each do |pick|
			player = pick.nfl_player
			if ['QB', 'TE', 'DEF', 'K'].include?(player.position)
				if starters.key?(player.position)
					bench[player.position] << player
				else
					starters[player.position] = player
				end
			elsif player.position == 'RB'
				if starters.key?('RB1')
					if starters.key?('RB2') || starters.key?('WR3')
						bench['RB'] << player
					else
						starters['RB2'] = player	
					end
				else
					starters['RB1'] = player
				end
			else # WR
				if starters.key?('WR1')
					if starters.key?('WR2')
						if starters.key?('WR3') || starters.key?('RB2')
							bench['WR'] << player
						else
							starters['WR3'] = player
						end
					else
						starters['WR2'] = player	
					end
				else
					starters['WR1'] = player
				end
			end
		end

		[picks, starters, bench]
	end

end
