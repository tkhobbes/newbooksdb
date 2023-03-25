# frozen_string_literal: true

# preview for ShowMoreComponent
# this class smells of :reek:DuplicateMethodCall
class ShowMoreComponentPreview < ViewComponent::Preview

   # @!group Type

  # Show More
  # ---
  # Outputs a text "show all (n books)..." if there are books for the model given
  # If there aren't any books, it says "No books for this <model>", where <model> is the name of the model given
  def default_view
    render(ShowMoreComponent.new(
      model: 'Publisher',
      id: Publisher.first.id,
      items: Publisher.first.books
    ))
  end

  def no_books
    render(ShowMoreComponent.new(
      model: 'Publisher',
      id: Publisher.first.id,
      items: []
    ))
  end

  # @!endgroup

end
