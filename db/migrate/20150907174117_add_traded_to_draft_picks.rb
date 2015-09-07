class AddTradedToDraftPicks < ActiveRecord::Migration
  def change
    add_column :draft_picks, :traded, :boolean, default: false
  end
end
