class AddFallbackToBookFormat < ActiveRecord::Migration[7.0]
  def change
    add_column :book_formats, :fallback, :boolean, default: false
  end
end
