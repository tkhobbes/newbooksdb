class FixTagOwners < ActiveRecord::Migration[7.0]
  def change
    remove_index :tags, [:name, :user_id], unique: true
    remove_reference :tags, :user, null: false
  end
end
