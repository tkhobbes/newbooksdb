class RenameFormatToNameForBookformats < ActiveRecord::Migration[7.0]
  def change
    rename_column :book_formats, :format, :name
  end
end
