class AddExpertIdToMission < ActiveRecord::Migration
  def change
    add_column :missions, :expert_id, :integer
  end
end
