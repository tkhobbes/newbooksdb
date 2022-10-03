class AddNotNullToBookFormats < ActiveRecord::Migration[7.0]
  def change
    change_column_null :book_formats, :name, false
  end
end
