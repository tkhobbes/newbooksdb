class ChangeBookFormatFromIntegerToString < ActiveRecord::Migration[7.0]
  def change
    change_column :book_formats, :format, :string
  end
end
