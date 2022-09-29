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
  def generate_user_avatar_svg(css)
    inline_svg_tag('avatar.svg', class: css)
  end

  # helper method to get number of users from cache
  def users_count
    Rails.cache.fetch('users-count') { User.count }
  end

end
