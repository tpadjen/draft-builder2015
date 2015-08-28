class DraftPick < ActiveRecord::Base
  belongs_to :nfl_player
  belongs_to :fantasy_team

  def self.unselected
  	where(nfl_player: nil).order(:number)
  end

  def self.selected
  	where.not(nfl_player: nil).order(:number)
  end

  def selected?
  	nfl_player != nil
  end

  def round
  	r = (number / 10) + 1
  	number % 10 == 0 ? r - 1 : r
  end

  def round_pick
  	number % 10 == 0 ? 10 : number % 10
  end

  def to_d
  	"#{round}.#{round_pick}"
  end
end
