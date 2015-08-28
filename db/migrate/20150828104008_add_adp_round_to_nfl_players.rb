class AddAdpRoundToNflPlayers < ActiveRecord::Migration
  def change
    add_column :nfl_players, :adp_round, :decimal
  end
end
