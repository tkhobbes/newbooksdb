class AddNotNullToBooks < ActiveRecord::Migration[7.0]
  def change
    change_column_null :books, :title, false
  end
end
