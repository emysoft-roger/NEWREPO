class ChangeTel < ActiveRecord::Migration
  def change
    change_column :experts, :tel, :string
  end
end
