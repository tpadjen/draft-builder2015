class CreateNflTeams < ActiveRecord::Migration
  def change
    create_table :nfl_teams do |t|
      t.string :nickname
      t.string :city
      t.string :shortname

      t.timestamps null: false
    end
  end
end
