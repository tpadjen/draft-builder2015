class NflPlayer < ActiveRecord::Base
  belongs_to :nfl_team

  validates :position, inclusion: {in: ['QB', 'WR', 'RB', 'TE', 'DEF', 'K']}

  def name
  	"#{first_name} #{last_name}".strip
  end

end
