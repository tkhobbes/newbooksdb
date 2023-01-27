# frozen_string_literal: true

# == Schema Information
#
# Table name: books_authors
#
#  id        :bigint           not null, primary key
#  author_id :bigint           not null
#  book_id   :bigint           not null
#
# Indexes
#
#  index_books_authors_on_author_id              (author_id)
#  index_books_authors_on_book_id                (book_id)
#  index_books_authors_on_book_id_and_author_id  (book_id,author_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (author_id => authors.id)
#  fk_rails_...  (book_id => books.id)
#
# rubocop:disable Rails/ApplicationRecord
class BooksAuthor < ActiveRecord::Base
  belongs_to :author, counter_cache: :books_count
  belongs_to :book
end
# rubocop:enable Rails/ApplicationRecord
