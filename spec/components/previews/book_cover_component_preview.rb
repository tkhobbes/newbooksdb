# frozen_string_literal: true

class BookCoverComponentPreview < ViewComponent::Preview
  # Book Cover
  # ----
  # renders cover of a book or a generic SVG if none available
  # @param size select { choices: [default, small, medium, large] }
  def default(size: :default)
    render(BookCoverComponent.new(book: Book.find(2), size:))
  end
end
