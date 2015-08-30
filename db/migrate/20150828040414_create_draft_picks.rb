class CreateDraftPicks < ActiveRecord::Migration
  def change
    create_table :draft_picks do |t|
      t.integer :number
      t.references :nfl_player, index: true, foreign_key: true
      t.references :fantasy_team, index: true

      t.timestamps null: false
    end
  end
end
