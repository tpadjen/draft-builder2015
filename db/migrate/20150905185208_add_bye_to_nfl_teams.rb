class AddByeToNflTeams < ActiveRecord::Migration
  def change
    add_column :nfl_teams, :bye, :integer
  end
end
