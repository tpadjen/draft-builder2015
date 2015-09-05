class NflPlayer < ActiveRecord::Base
  belongs_to :nfl_team
  has_many :draft_picks
  has_many :fantasy_teams, through: :draft_picks
  has_many :leagues, through: :draft_picks

  VALID_POSITIONS = ['QB', 'WR', 'RB', 'TE', 'DEF', 'K']

  validates :position, inclusion: {in: VALID_POSITIONS}

  def name
  	"#{first_name} #{last_name}".strip
  end

  def self.position_valid?(pos)
  	VALID_POSITIONS.include?(pos.upcase)
  end

  def picked?(league)
  	leagues.include?(league)
  end

  def fantasy_team(league)
    fantasy_teams.where(league: league).first
  end

end
