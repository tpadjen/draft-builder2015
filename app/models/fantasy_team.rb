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
		HymmRoster.new(draft_picks).build
	end

end
