class AddImageIdToExpert < ActiveRecord::Migration
  def change
    add_column :experts, :image_id, :string
  end
end
