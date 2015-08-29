class AddAdpEspnToNflPlayers < ActiveRecord::Migration
  def change
    add_column :nfl_players, :adp_espn, :decimal
  end
end
