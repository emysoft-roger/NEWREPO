class AddIndexMissions < ActiveRecord::Migration
  def change
    add_index :missions, :validated
    add_index :missions, :validated_at
    add_index :missions, :created_at
    add_index :missions, :state
    add_index :missions, :budget_min
    add_index :missions, :budget_max
    add_index :missions, :duration_min
    add_index :missions, :duration_max
  end
end
