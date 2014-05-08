class Remove < ActiveRecord::Migration
  def change
    remove_column :missions, :mission_type_id, :integer
    drop_table :mission_types
    add_column :missions, :category_id, :integer
  end
end
