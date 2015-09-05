class FantasyTeam::Roster
	
	attr_accessor :draft_picks

	def initialize(draft_picks)
		@picks = draft_picks.includes(nfl_player: :nfl_team).order(:number)
	end

end