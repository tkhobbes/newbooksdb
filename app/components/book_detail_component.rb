# frozen_string_literal: true

# ViewComponent for displaying all Book Details. Used on the Book Show page.
class BookDetailComponent < ViewComponent::Base
  include BooksHelper

  # initializer - takes an instance of a book active record as parameter
  def initialize(book:)
    @book = book
  end

end
