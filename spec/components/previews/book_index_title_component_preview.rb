# frozen_string_literal: true

# preview for BookIndexTitleComponent
class BookIndexTitleComponentPreview < ViewComponent::Preview

  # @!group options

  # Book Index Title
  # ----
  # A component that creates the title for the book index page dynamically
  def default_title
    render(BookIndexTitleComponent.new(params: {}))
  end

  def no_books
    render(BookIndexTitleComponent.new(params: { no_shelf: 'true' }))
  end

  def my_books
    render(BookIndexTitleComponent.new(params: { my_books: '1' }))
  end

  def shelf_books
    render(BookIndexTitleComponent.new(params: { shelf_books: '1' }))
  end

  #@!endgroup
end
