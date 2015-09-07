class AddNameToFantasyTeams < ActiveRecord::Migration
  def change
    add_column :fantasy_teams, :name, :string
  end
end
