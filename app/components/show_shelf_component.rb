# frozen_string_literal: true

class ShowShelfComponent < ViewComponent::Base
  def initialize(book:, owner:)
    super
    @book = book
    @owner = owner
  end

  def show?
    @book.owner == @owner && @book.shelf
  end

  def show_shelf(css_classes)
    link_to(@book.shelf.name,
      books_path(shelf_books: @book.shelf.id),
      class: css_classes
    )
  end

end
