class RemoveExpertIdFromCompetence < ActiveRecord::Migration
  def change
    remove_index :competences, column: :expert_id
    remove_index :secteurs, column: :expert_id

    remove_column :competences, :expert_id, :integer
    remove_column :secteurs, :expert_id, :integer

    rename_column :expert_competences, :exp_yaers, :exp_years
  end
end
