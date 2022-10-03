class AddUniquenessToBookFormatName < ActiveRecord::Migration[7.0]
  def change
    add_index :book_formats, :name, unique: true
  end
end
