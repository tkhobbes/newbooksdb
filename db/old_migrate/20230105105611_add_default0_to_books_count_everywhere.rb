class AddDefault0ToBooksCountEverywhere < ActiveRecord::Migration[7.0]
  def change
    change_column :authors, :books_count, :integer, default: 0
    change_column :book_formats, :books_count, :integer, default: 0
    change_column :genres, :books_count, :integer, default: 0
    change_column :owners, :books_count, :integer, default: 0
    change_column :publishers, :books_count, :integer, default: 0
    change_column :shelves, :books_count, :integer, default: 0
  end
end
