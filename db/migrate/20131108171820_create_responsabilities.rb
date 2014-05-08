class CreateResponsabilities < ActiveRecord::Migration
  def change
    create_table :responsabilities do |t|
      t.string :organisme
      t.string :poste
      t.text :description
      t.belongs_to :expert, index: true

      t.timestamps
    end
  end
end
