class AddKeeperToDraftPicks < ActiveRecord::Migration
  def change
    add_column :draft_picks, :keeper, :boolean, default: false
  end
end
