class AddOwnersToBooks < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :owner, null: false, foreign_key: true
    add_index :books, [:title, :owner_id], unique: true
  end
end
