class Renaming < ActiveRecord::Migration
  def change
    rename_table :secteur_experts, :expert_secteurs
  end
end
