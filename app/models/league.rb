class League < ActiveRecord::Base
	has_many :fantasy_teams, dependent: :destroy
	has_many :draft_picks, dependent: :destroy

	enum roster_style: [:hymm, :beavers]

	validates :size, presence: true, 
		numericality: {only_integer: true, greater_than_or_equal_to: 2}

	validates :name, uniqueness: true

	accepts_nested_attributes_for :fantasy_teams
	validates_associated :fantasy_teams

	def year
		created_at.year
	end
end
