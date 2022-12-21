# frozen_string_literal: true

# == Schema Information
#
# Table name: books_genres
#
#  book_id  :bigint           not null
#  genre_id :bigint           not null
#
# Indexes
#
#  index_books_genres_on_book_id               (book_id)
#  index_books_genres_on_book_id_and_genre_id  (book_id,genre_id) UNIQUE
#  index_books_genres_on_genre_id              (genre_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (genre_id => genres.id)
#

class BooksGenre < ActiveRecord::Base
  belongs_to :genre, counter_cache: :books_count
  belongs_to :book
end
