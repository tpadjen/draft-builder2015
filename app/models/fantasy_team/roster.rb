class FantasyTeam::Roster
	
	@@starting_spots = {
		'QB'  =>  1,
		'RB'  =>  2,
		'WR'  =>  2,
		'TE'  =>  1,
		'DEF' =>  1,
		'K'   =>  1
	}

	def self.build(draft_picks)
		starters = {}
		@@starting_spots.keys.each {|pos| starters[pos] = [] }

		bench = {
			'QB'  => [],
			'RB'  => [],
			'WR'  => [],
			'TE'  => [],
			'DEF' => [],
			'K'   => []
		}

		picks = draft_picks.includes(nfl_player: :nfl_team).order(:number)

		picks.selected.each do |pick|
			player = pick.nfl_player

			if spot = spot_for?(player, starters)
				starters[spot] << player
			else
				bench[player.position] << player
			end
		end

		starters.each do |spot, players|
			while starters[spot].count < @@starting_spots[spot]
				starters[spot] << nil
			end
		end

		[picks, starters, bench]
	end

	private

		def self.spot_for?(player, starters)
			starters.keys.each do |spot|
				return spot if spot =~ /#{player.position}/ && spot_is_available?(spot, starters)
			end
			nil
		end

		def self.spot_is_available?(spot, starters)
			starters[spot].count < @@starting_spots[spot]
		end

end