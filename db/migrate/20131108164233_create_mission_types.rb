class CreateMissionTypes < ActiveRecord::Migration
  def change
    create_table :mission_types do |t|
      t.string :text

      t.timestamps
    end
  end
end
