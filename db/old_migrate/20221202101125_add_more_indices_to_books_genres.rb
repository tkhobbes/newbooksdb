class AddMoreIndicesToBooksGenres < ActiveRecord::Migration[7.0]
  def change
    add_index :books_genres, :genre_id
    add_index :books_genres, :book_id
    add_index :books_genres, [:book_id, :genre_id], unique: true

    add_foreign_key :books_genres, :books
    add_foreign_key :books_genres, :genres
  end
end
