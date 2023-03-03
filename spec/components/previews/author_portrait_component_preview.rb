# frozen_string_literal: true

class AuthorPortraitComponentPreview < ViewComponent::Preview
  # Author Portrait
  # ----
  # renders portrait of an author or a generic SVG if none available
  # @param size select { choices: [default, small, medium, large] }
  def default(size: :default)
    render(AuthorPortraitComponent.new(author: Author.find(2), size:))
  end
end
