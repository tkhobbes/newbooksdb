# frozen_string_literal: true

# preview for the show synopsis component
class ShowSynopsisComponentPreview < ViewComponent::Preview
  def default_view
    render(ShowSynopsisComponent.new(book: Book.first))
  end

  def truncated_view
    render(ShowSynopsisComponent.new(book: Book.first, type: :truncated))
  end
end
