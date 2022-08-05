class AddBookFormatToBooks < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :book_format, null: false, foreign_key: true
  end
end
