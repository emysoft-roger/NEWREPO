class Change < ActiveRecord::Migration
  def change
    change_column :entreprises, :tel, :string
  end
end
