class AddExpertIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :expert_id, :integer
  end
end
