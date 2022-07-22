# frozen_string_literal: true

class BookCardComponent < ViewComponent::Base
  with_collection_parameter :book
  include BooksHelper

  def initialize(book:)
    @book = book
  end

end
