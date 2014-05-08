class CreateSecteurExperts < ActiveRecord::Migration
  def change
    create_table :secteur_experts do |t|
      t.belongs_to :expert, index: true
      t.belongs_to :secteur, index: true
      t.integer :exp_years

      t.timestamps
    end
  end
end
