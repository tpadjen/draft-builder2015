class NflTeam < ActiveRecord::Base

	validates :shortname, uniqueness: true

	has_many :nfl_players

end
