class AddDescriptionToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :description, :text
  end
end
