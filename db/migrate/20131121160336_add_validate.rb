class AddValidate < ActiveRecord::Migration
  def change
    add_column :missions, :validated, :integer
  end
end
