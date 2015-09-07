class AddAdpYahooToNflPlayers < ActiveRecord::Migration
  def change
    add_column :nfl_players, :adp_yahoo, :decimal
  end
end
