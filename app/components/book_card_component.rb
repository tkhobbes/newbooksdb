# frozen_string_literal: true

# ViewComponent for a book card (used in index page).
# This is the exhaustive view of a card.
class BookCardComponent < ViewComponent::Base
  with_collection_parameter :book
  include BooksHelper

  # initializer - takes an instance of a book active record as a parameter
  def initialize(book:)
    super
    @book = book
  end

end
