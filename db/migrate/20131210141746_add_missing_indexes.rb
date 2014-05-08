class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :missions, :secteur_id
    add_index :missions, :competence_id
    add_index :missions, :category_id
    add_index :missions, :expert_id
    add_index :notes, :expert_id
    add_index :notes, :mission_id
  end
end