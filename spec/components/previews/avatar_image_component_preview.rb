# frozen_string_literal: true

class AvatarImageComponentPreview < ViewComponent::Preview
  # AvatarImage
  # ----
  # Renders the image of a user (avatar) or a generic SVG if none available
  # @param size select { choices: [default, small, medium, large] }
  def default(size: :medium)
    render(AvatarImageComponent.new(profile: Profile.first, size: size))
  end
end
