# frozen_string_literal: true

class BookCoverComponent < ViewComponent::Base

  SIZE_MAP = {
      large: [500, 'placeholder-large'],
      medium: [300, 'placeholder-medium'],
      small: [150, 'placeholder-small'],
      default: [50, 'placeholder-default']
  }

  def initialize(book:, size: :default, link: false)
    @book = book
    @size = size
    @link = link
    super
  end

  # returns either the cover image of a book or a placeholder SVG
  # @return [String] (HTML image tag or SVG tag)
  def cover_image
    img_size = SIZE_MAP[@size][0]
    css_tag = SIZE_MAP[@size][1]
    cover = @book.cover
    if cover.attached?
      cover_generate = cover.variant(resize_to_limit: [img_size, img_size])
      if @link
          cover_with_link(cover_generate, img_size)
      else
          image_tag(cover_generate, size: img_size)
      end
    else
      generate_book_cover_svg(css_tag, "#{img_size}px")
    end
  end


  private

  def cover_with_link(cover, size)
    link_to rails_blob_path(@book.cover, disposition: 'inline') do
      image_tag(cover, size:)
    end
  end

  # generates a SVG tag with the given class
  def generate_book_cover_svg(css, size)
    inline_svg_tag('book.svg', class: css, size:)
  end

end
