class FantasyTeam < ActiveRecord::Base
	has_many :draft_picks
	has_many :nfl_players, through: :draft_picks
	belongs_to :league

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
		roster_class = "FantasyTeam::#{league.roster_style.titleize}Roster".constantize
		roster_class.build(draft_picks)
	end

end
