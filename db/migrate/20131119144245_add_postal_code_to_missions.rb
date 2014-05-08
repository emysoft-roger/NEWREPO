class AddPostalCodeToMissions < ActiveRecord::Migration
  def change
    add_column :missions, :postal_code, :string
  end
end
