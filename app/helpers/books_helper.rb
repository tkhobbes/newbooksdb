# frozen_string_literal: true

# Book Helper module includes various view helpers
module BooksHelper

  # sets the title to display on the index page for books, depending on what we see
  # this method smells of :reek:DuplicateMethodCall
  def book_index_title
    if params[:my_books]
      'My Books'
    elsif params[:shelf_books]
      "Books in Shelf '#{Shelf.find(params[:shelf_books]).name}'"
    else
      'All Books'
    end
  end

  # store the number of books in a cache
  def books_count
    Rails.cache.fetch('books-count') { Book.count }
  end

  # returns either the cover image of a book or a placeholder SVG
  # @return [String] (HTML image tag or SVG tag)
  # This method smells of :reek:DuplicateMethodCall
  # This method smells of :reek:TooManyStatements
  # rubocop:disable Metrics/MethodLength
  def cover_image(book, options = {})
    cover_map = {
      large: [500, 'placeholder-large'],
      medium: [300, 'placeholder-medium'],
      small: [150, 'placeholder-small'],
      default: [50, 'placeholder-default']
    }
    size = options[:size]&.to_sym || :default
    # below the duplicate method call
    img_size = cover_map[size][0]
    css_tag = cover_map[size][1]

    cover = book.cover
    if cover.attached?
      cover_generate = cover.variant(resize_to_limit: [img_size, img_size])
      options[:link] == "true" ? cover_with_link(book, cover_generate) : image_tag(cover_generate)
    else
      generate_book_cover_svg(css_tag)
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def cover_with_link(book, cover)
    link_to rails_blob_path(book.cover, disposition: "inline") do
      image_tag(cover)
    end
  end

  # generates a SVG tag with the given class
  def generate_book_cover_svg(css)
    inline_svg_tag('book.svg', class: css)
  end

end
