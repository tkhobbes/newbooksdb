# frozen_string_literal: true

# this component shows the portrait picture of an author or a generic SVG
class AuthorPortraitComponent < ViewComponent::Base
  # returns either the portrait of an author or a placeholder SVG

  PORTRAIT_SIZES = {
    large: [500, 'placeholder-large'],
    medium: [300, 'placeholder-medium'],
    small: [150, 'placeholder-small'],
    default: [50, 'placeholder-default']
  }.freeze

  def initialize(author:, size: :default)
    @author = author
    @size = size
    super
  end

  # this method smells of :reek:DuplicateMethodCall
  def portrait_image
    img_size = PORTRAIT_SIZES[@size][0]
    css_tag = PORTRAIT_SIZES[@size][1]

    portrait = @author.portrait
    if portrait.attached?
      image_tag(portrait.variant(resize_to_limit: [img_size, img_size]), size: img_size)
    else
      generate_author_portrait_svg(css_tag, "#{img_size}px")
    end
  end
    private

  # generates a SVG tag with the given class
  def generate_author_portrait_svg(css, size)
    inline_svg_tag('person.svg', class: css, size:)
  end

end
