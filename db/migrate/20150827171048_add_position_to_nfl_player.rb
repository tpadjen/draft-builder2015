class AddPositionToNflPlayer < ActiveRecord::Migration
  def change
    add_column :nfl_players, :position, :string
  end
end
