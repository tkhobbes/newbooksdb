class AddIndicesToBooks < ActiveRecord::Migration[7.0]
  def change
    add_index :books, :title
    add_index :books, :original_title
    add_index :books, :isbn
    add_index :books, :source_id

    change_column :books, :author_id, :bigint
    change_column :books, :shelf_id, :bigint
    change_column :books, :publisher_id, :bigint
    change_column :books, :owner_id, :bigint

    add_foreign_key :books, :authors
    add_foreign_key :books, :shelves
    add_foreign_key :books, :publishers
    add_foreign_key :books, :owners
  end
end
