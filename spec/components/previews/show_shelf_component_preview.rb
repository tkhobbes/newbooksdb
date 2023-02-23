# frozen_string_literal: true

# preview for ShelfComponent
class ShowShelfComponentPreview < ViewComponent::Preview

  # Show Shelf
  # ---
  # Displays the shelf a book is in, if there is any, but only visible to owner of book.
  def default
    render(ShowShelfComponent.new(book: Book.first, owner: Owner.first))
  end
end
