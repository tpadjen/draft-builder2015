class AddRosterStyleToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :roster_style, :integer
  end
end
