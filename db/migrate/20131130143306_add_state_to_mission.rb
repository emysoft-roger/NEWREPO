class AddStateToMission < ActiveRecord::Migration
  def change
    add_column :missions, :state, :integer
  end
end
