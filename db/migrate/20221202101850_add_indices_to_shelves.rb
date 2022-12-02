class AddIndicesToShelves < ActiveRecord::Migration[7.0]
  def change
    add_index :shelves, :name
    add_foreign_key :shelves, :owners
  end
end
