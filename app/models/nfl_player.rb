class NflPlayer < ActiveRecord::Base
  belongs_to :nfl_team

  @@valid_positions = ['QB', 'WR', 'RB', 'TE', 'DEF', 'K']

  validates :position, inclusion: {in: @@valid_positions}

  def name
  	"#{first_name} #{last_name}".strip
  end

  def self.position_valid?(pos)
  	@@valid_positions.include?(pos.upcase)
  end

  def self.valid_positions
  	@@valid_positions
  end

end
