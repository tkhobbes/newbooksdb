class AddBooksCountToOwners < ActiveRecord::Migration[7.0]
  def change
    add_column :owners, :books_count, :integer
  end
end
