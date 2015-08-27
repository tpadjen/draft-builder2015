class NflTeam < ActiveRecord::Base

	validates :shortname, uniqueness: true

end
