class AddPriceToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :price, :float
  end
end
