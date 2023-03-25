# frozen_string_literal: true

# preview for shelf menu component
class ShelfMenuComponentPreview < ViewComponent::Preview
  # ShelfMenu
  # ----
  # Displays a tabbed navigation for the shelves of an owner.
  # includes the default shelves "all books" and "books in no shelves",
  # and for each owner, "my books".
  # If an owner has more that 2 shelves, remaining shelves are grouped in a menu
  def default
    render(ShelfMenuComponent.new(owner: Owner.first))
  end
end
