class AddLeagueToFantasyTeams < ActiveRecord::Migration
  def change
    add_reference :fantasy_teams, :league, index: true
    add_foreign_key :fantasy_teams, :leagues, on_delete: :cascade
  end
end
