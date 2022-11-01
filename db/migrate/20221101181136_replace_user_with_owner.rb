class ReplaceUserWithOwner < ActiveRecord::Migration[7.0]
  def change
    # replace columns in Books - also remove index on user_id
    remove_index :books, [:title, :user_id], unique: true
    remove_reference :books, :user, index: true
    add_reference :books, :owner, null: false
    add_index :books, [:title, :owner_id], unique: true

    # replace columns in Shelves - also remove index on user_id and foreign key
    remove_index :shelves, [:name, :user_id], unique: true
    remove_reference :shelves, :user, null: false, foreign_key: true
    add_reference :shelves, :owner, null: false
    add_index :shelves, [:name, :owner_id], unique: true

    # replace columns in Tags - also remove index and foreign key
    add_reference :tags, :owner, null: false
    add_index :shelves, [:name, :owner_id], unique: true
  end
end
