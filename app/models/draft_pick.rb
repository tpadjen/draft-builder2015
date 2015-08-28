class DraftPick < ActiveRecord::Base
  belongs_to :nfl_player
  belongs_to :fantasy_team
end
