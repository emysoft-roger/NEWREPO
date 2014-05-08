class CreateExpertCompetences < ActiveRecord::Migration
  def change
    create_table :expert_competences do |t|
      t.belongs_to :competence, index: true
      t.belongs_to :expert, index: true
      t.integer :exp_yaers

      t.timestamps
    end
  end
end
