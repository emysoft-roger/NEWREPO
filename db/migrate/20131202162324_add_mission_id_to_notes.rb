class AddMissionIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :mission_id, :integer
  end
end
