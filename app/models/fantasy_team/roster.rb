class FantasyTeam::Roster

	def self.build(starting_spots, draft_picks)
		@@starting_spots = starting_spots

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

		picks.selected.reorder(keeper: :desc, number: :asc).each do |pick|
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