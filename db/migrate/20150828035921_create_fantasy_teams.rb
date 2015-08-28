class CreateFantasyTeams < ActiveRecord::Migration
  def change
    create_table :fantasy_teams do |t|
      t.string :owner
      t.string :pick_number

      t.timestamps null: false
    end
  end
end
