class AddTownToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :town, :string
  end
end
