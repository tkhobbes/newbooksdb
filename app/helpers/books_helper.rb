# frozen_string_literal: true

# Book Helper module includes various view helpers
module BooksHelper

  # sets the title to display on the index page for books, depending on what we see
  # this method smells of :reek:DuplicateMethodCall
  def book_index_title
    letter_title = params[:letter] ? " starting with #{params[:letter].upcase}" : ''
    if params[:my_books]
      "My Books#{letter_title}"
    elsif params[:shelf_books]
      "Books in Shelf '#{Shelf.find(params[:shelf_books]).name}'#{letter_title}"
    else
      "All Books#{letter_title}"
    end
  end

  def scoped_books_path(show_hash)
    new_scopes = current_scopes.merge(show_hash)
    books_path(new_scopes)
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
      if options[:link] == 'true'
          cover_with_link(book, cover_generate, img_size)
      else
          image_tag(cover_generate, size: img_size)
      end
    else
      generate_book_cover_svg(css_tag, "#{img_size}px")
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def cover_with_link(book, cover, size)
    link_to rails_blob_path(book.cover, disposition: 'inline') do
      image_tag(cover, size:)
    end
  end

  # generates a SVG tag with the given class
  def generate_book_cover_svg(css, size)
    inline_svg_tag('book.svg', class: css, size:)
  end

end
