# frozen_string_literal: true

# this component shows the avatar of a user or a generic SVG
class AvatarImageComponent < ViewComponent::Base
  SIZE_MAP = {
      large: [300, 'placeholder-large'],
      medium: [200, 'placeholder-medium'],
      small: [100, 'placeholder-small'],
      default: [50, 'placeholder-default']
  }.freeze

  def initialize(profile:, size: :default)
    @profile = profile
    @size = size
    super
  end
  # returns either the profile image of a user or a placeholder SVG
  # this method smells of :reek:DuplicateMethodCall
  def avatar_image
    img_size = SIZE_MAP[@size][0]
    css_tag = SIZE_MAP[@size][1]

    avatar = @profile.avatar
    if avatar.attached?
      image_tag(avatar.variant(resize_to_limit: [img_size, img_size]))
    else
      generate_user_avatar_svg(css_tag)
    end
  end

  private

  # generates a SVG tag with the given class
  def generate_user_avatar_svg(css)
    inline_svg_tag('avatar.svg', class: css)
  end

end
