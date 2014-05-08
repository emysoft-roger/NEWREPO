class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :description
      t.float :ponctualite
      t.float :qualite
      t.float :disponibilite
      t.float :courtoisie

      t.timestamps
    end
  end
end
