class ValidateAt < ActiveRecord::Migration
  def change
    add_column :missions, :validated_at, :datetime
  end
end
