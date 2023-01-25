# frozen_string_literal: true

class BooksAuthor < ActiveRecord::Base
  belongs_to :author, counter_cache: :books_count
  belongs_to :book
end
