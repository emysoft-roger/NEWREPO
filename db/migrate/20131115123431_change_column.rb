class ChangeColumn < ActiveRecord::Migration
  def change
    change_column :experiences, :description, :text
    change_column :responsabilities, :description, :text
    change_column :experts, :services, :text
  end
end
