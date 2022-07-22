# frozen_string_literal: true

class BookDetailComponent < ViewComponent::Base
  include BooksHelper

  def initialize(book:)
    @book = book
  end

end
