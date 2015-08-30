class League < ActiveRecord::Base
	has_many :fantasy_teams, dependent: :destroy
	has_many :draft_picks, dependent: :destroy
end
