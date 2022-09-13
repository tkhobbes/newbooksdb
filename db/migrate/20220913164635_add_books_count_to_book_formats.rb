class AddBooksCountToBookFormats < ActiveRecord::Migration[7.0]
  def change
    add_column :book_formats, :books_count, :integer
  end
end
