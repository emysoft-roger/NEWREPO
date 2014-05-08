class ChangeServicesTypeInExpert < ActiveRecord::Migration
  def change
    change_column :experts, :services, :text
  end
end
