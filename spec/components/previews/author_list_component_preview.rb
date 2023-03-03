# frozen_string_literal: true

class AuthorListComponentPreview < ViewComponent::Preview
  # Author List
  # ----
  # Renders a list of authors, and takes a type parameter to determine how the list
  # looks like:
  # - :list -> Lists all authors, separated by a comma
  # - :single -> Shows only the firt author, and adds "et al." if there are more
  # - :by -> shows a "by" prefix, and the first author, and adds "et al." if there are more
  # @param type select { choices: [list, single, by] }
  def default(type: :list)
    render(AuthorListComponent.new(book: Book.first, type: type))
  end
end
