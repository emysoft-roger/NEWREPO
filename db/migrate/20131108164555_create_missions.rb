class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.string :name
      t.belongs_to :mission_type, index: true
      t.belongs_to :entreprise, index: true
      t.integer :budget_min
      t.integer :budget_max
      t.integer :duration_min
      t.integer :duration_max

      t.timestamps
    end
  end
end
