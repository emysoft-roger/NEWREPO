class CreateSecteurs < ActiveRecord::Migration
  def change
    create_table :secteurs do |t|
      t.string :name
      t.belongs_to :expert, index: true

      t.timestamps
    end
  end
end
