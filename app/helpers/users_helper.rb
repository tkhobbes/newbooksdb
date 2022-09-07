# frozen_string_literal: true

# Users Helper module includes various view helpers
module UsersHelper
    # returns either the cover image of a book or a placeholder SVG
  # @return [String] (HTML image tag or SVG tag)
  # This method smells of :reek:DuplicateMethodCall
  # This method smells of :reek:TooManyStatements
  # rubocop:disable Metrics/MethodLength
  def avatar_image(user, options = {})
    avatar_map = {
      large: [300, 'placeholder-large'],
      medium: [200, 'placeholder-medium'],
      small: [100, 'placeholder-small'],
      default: [50, 'placeholder-default']
    }
    size = options[:size]&.to_sym || :default
    # below the duplicate method call
    img_size = avatar_map[size][0]
    css_tag = avatar_map[size][1]

    avatar = user.avatar
    # rubocop:disable Layout/LineLength
    avatar.attached? ? image_tag(avatar.variant(resize_to_limit: [img_size, img_size])) : generate_user_avatar_svg(css_tag)
    # rubocop:enable Layout/LineLength
  end
  # rubocop:enable Metrics/MethodLength

  # generates a SVG tag with the given class
  # rubocop:disable Metrics/MethodLength
  def generate_user_avatar_svg(css)
    content_tag(
      :svg,
      xlmns: 'http://www.w3.org/2000/svg',
      class: css,
      viewBox: '0 0 24 24',
      fill: 'none',
      stroke: 'currentColor',
      'stroke-width': '2'
    ) do
      # rubocop:disable Layout/LineLength
      tag.path('stroke-linecap': 'round',
        'stroke-linejoin': 'round',
        d: 'M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z')
        # rubocop:enable Layout/LineLength
    end
  end
  # rubocop:enable Metrics/MethodLength

end
