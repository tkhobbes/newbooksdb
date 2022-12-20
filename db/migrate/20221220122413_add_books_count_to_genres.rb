class AddBooksCountToGenres < ActiveRecord::Migration[7.0]
  def change
    add_column :genres, :books_count, :integer, default: 0
  end
end
