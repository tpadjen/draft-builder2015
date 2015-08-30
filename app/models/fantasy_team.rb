class FantasyTeam < ActiveRecord::Base
	has_many :draft_picks
	has_one :league
	has_many :nfl_players, through: :draft_picks
end
