class DraftPick < ActiveRecord::Base
  belongs_to :league
  belongs_to :nfl_player
  belongs_to :fantasy_team

  validate :roster_is_valid

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
  	r = (number / league.size) + 1
  	number % league.size == 0 ? r - 1 : r
  end

  def round_pick
  	number % league.size == 0 ? league.size : number % league.size
  end

  def to_d
  	"#{round}.#{round_pick}"
  end

  def to_json
    {
      owner: fantasy_team.owner,
      player: nfl_player ? nfl_player.name : nil,
      player_id: nfl_player ? nfl_player.id : nil,
      number: number,
      decimal: to_d,
      picks_left: fantasy_team.picks_left
    }
  end

  def limited_positions
    fantasy_team ? fantasy_team.limited_positions : NflPlayer::VALID_POSITIONS
  end

  def roster_is_valid
    if nfl_player && fantasy_team 
      if fantasy_team.at_limit?(nfl_player.position)
        errors.add(:roster, " has reached the limit of #{nfl_player.position}s")
      else
        needs = fantasy_team.absolute_position_needs
        if needs.count > 0 && !needs.include?(nfl_player.position) 
          errors.add(:roster, " only has room for [#{needs.join(', ')}]")
        end
      end
    end
  end
end
