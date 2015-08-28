class AddAdpFfcToNflPlayers < ActiveRecord::Migration
  def change
    add_column :nfl_players, :adp_ffc, :decimal
  end
end
