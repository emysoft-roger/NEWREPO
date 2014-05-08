class CreateEntreprises < ActiveRecord::Migration
  def change
    create_table :entreprises do |t|
      t.string :name
      t.integer :tel
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
