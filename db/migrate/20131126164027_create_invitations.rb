class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :expert, index: true
      t.references :mission, index: true
      t.integer :state

      t.timestamps
    end
  end
end
