# frozen_string_literal: true

# # shows shelfs for individual books
class ShowShelfComponent < ViewComponent::Base
  def initialize(book:, owner:)
    super
    @book = book
    @owner = owner
  end

  # determines whether we show the shelf of a book or not
  def show?
    @book.owner == @owner && @book.shelf
  end

  # shows the shelf of a book
  # this method smells of :reek:DuplicateMethodCall
  def show_shelf(css_classes)
    link_to(@book.shelf.name,
      books_path(shelf_books: @book.shelf.id),
      class: css_classes
    )
  end

end
