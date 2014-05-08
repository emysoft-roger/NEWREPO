class CreateExperts < ActiveRecord::Migration
  def change
    create_table :experts do |t|
      t.string :first_name
      t.string :last_name
      t.integer :tel
      t.datetime :birthdate
      t.string :profile_title
      t.string :services
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
