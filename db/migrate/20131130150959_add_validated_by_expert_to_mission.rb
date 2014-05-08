class AddValidatedByExpertToMission < ActiveRecord::Migration
  def change
    add_column :missions, :validated_by_expert, :boolean
  end
end
