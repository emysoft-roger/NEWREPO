class AddEntreprisePriceToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :entreprise_price, :float
  end
end
