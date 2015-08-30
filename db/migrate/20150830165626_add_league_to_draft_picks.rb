class AddLeagueToDraftPicks < ActiveRecord::Migration
  def change
    add_reference :draft_picks, :league, index: true, foreign_key: false
    add_foreign_key :draft_picks, :leagues, on_delete: :cascade
  end
end
