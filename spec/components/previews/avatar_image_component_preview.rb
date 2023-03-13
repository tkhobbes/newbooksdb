# frozen_string_literal: true

# preview for avatar image component
# rubocop:disable Style/HashSyntax
class AvatarImageComponentPreview < ViewComponent::Preview
  # AvatarImage
  # ----
  # Renders the image of a user (avatar) or a generic SVG if none available
  # @param size select { choices: [default, small, medium, large] }
  def default(size: :medium)
    render(AvatarImageComponent.new(profile: Profile.first, size: size))
  end
end
# rubocop:enable Style/HashSyntax
