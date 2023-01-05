# frozen_string_literal: true

module AuthorsHelper
  # store the number of authors in a cache
  def authors_count
    Rails.cache.fetch('authors-count') { Author.count }
  end

  # returns either the portrait of an author or a placeholder SVG
  # This method smells of :reek:DuplicateMethodCall
  # This method smells of :reek:TooManyStatements
  # rubocop:disable Metrics/MethodLength
  def portrait_image(author, options = {})
    portrait_map = {
      large: [500, 'placeholder-large'],
      medium: [300, 'placeholder-medium'],
      small: [150, 'placeholder-small'],
      default: [50, 'placeholder-default']
    }
    size = options[:size]&.to_sym || :default
    # below the duplicate method call
    img_size = portrait_map[size][0]
    css_tag = portrait_map[size][1]

    portrait = author.portrait
    if portrait.attached?
      image_tag(portrait.variant(resize_to_limit: [img_size, img_size]), size: img_size)
    else
      generate_author_portrait_svg(css_tag, "#{img_size}px")
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  # generates a SVG tag with the given class
  def generate_author_portrait_svg(css, size)
    inline_svg_tag('person.svg', class: css, size: size)
  end
end
