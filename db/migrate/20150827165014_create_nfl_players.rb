class CreateNflPlayers < ActiveRecord::Migration
  def change
    create_table :nfl_players do |t|
      t.string :first_name
      t.string :last_name
      t.integer :rank
      t.integer :position_rank
      t.decimal :projected_points
      t.references :nfl_team, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
