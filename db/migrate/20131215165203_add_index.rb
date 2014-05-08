class AddIndex < ActiveRecord::Migration
  def change
    add_index :experts, :profile_title
    add_index :experts, :services
    add_index :experts, :created_at
  end
end
