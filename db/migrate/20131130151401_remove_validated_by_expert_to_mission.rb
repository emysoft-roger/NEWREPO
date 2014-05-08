class RemoveValidatedByExpertToMission < ActiveRecord::Migration
  def change
    remove_column :missions, :validated_by_expert
  end
end
