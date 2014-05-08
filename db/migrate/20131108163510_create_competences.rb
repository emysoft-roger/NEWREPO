class CreateCompetences < ActiveRecord::Migration
  def change
    create_table :competences do |t|
      t.string :name
      t.belongs_to :expert, index: true

      t.timestamps
    end
  end
end
