class AddBooksCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :books_count, :integer
  end
end
