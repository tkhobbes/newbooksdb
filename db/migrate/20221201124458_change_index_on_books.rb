class ChangeIndexOnBooks < ActiveRecord::Migration[7.0]
  def change
    remove_index :books, name: 'index_books_on_title_and_owner_id'
    add_index :books, [:source_id, :owner_id], unique: true
    add_index :books, [:isbn, :owner_id], unique: true
  end
end
