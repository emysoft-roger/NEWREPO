class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :entreprise
      t.string :poste
      t.text :description
      t.belongs_to :expert, index: true

      t.timestamps
    end
  end
end
