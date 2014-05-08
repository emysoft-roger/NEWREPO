class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.references :expert, index: true
      t.references :mission, index: true
      t.text :motivation
      t.integer :state

      t.timestamps
    end
  end
end
