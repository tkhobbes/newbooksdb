class AddNotNullToShelves < ActiveRecord::Migration[7.0]
  def change
    change_column_null :shelves, :name, false
  end
end
