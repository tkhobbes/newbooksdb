class AddCounterCacheToShelf < ActiveRecord::Migration[7.0]
  def change
    add_column :shelves, :books_count, :integer
  end
end
