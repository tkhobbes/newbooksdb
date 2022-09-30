class AddBooksCountToPublishers < ActiveRecord::Migration[7.0]
  def change
    add_column :publishers, :books_count, :integer
  end
end
