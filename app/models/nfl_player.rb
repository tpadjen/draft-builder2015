class NflPlayer < ActiveRecord::Base
  belongs_to :nfl_team
  has_one :draft_pick
  has_one :fantasy_team, through: :draft_pick

  VALID_POSITIONS = ['QB', 'WR', 'RB', 'TE', 'DEF', 'K']

  validates :position, inclusion: {in: VALID_POSITIONS}

  def name
  	"#{first_name} #{last_name}".strip
  end

  def self.position_valid?(pos)
  	VALID_POSITIONS.include?(pos.upcase)
  end

  def picked?
  	fantasy_team != nil
  end

end
