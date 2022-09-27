class AddShelfIdToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :shelf_id, :integer
  end
end
