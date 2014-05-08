class CreateCursus < ActiveRecord::Migration
  def change
    create_table :cursus do |t|
      t.string :diplome
      t.string :university
      t.integer :years
      t.belongs_to :expert, index: true

      t.timestamps
    end
  end
end
