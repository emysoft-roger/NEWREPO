class AddSecteurIdAndCompetenceIdToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :secteur_id, :integer
    add_column :missions, :competence_id, :integer
  end
end
