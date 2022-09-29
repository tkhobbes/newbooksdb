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

  # returns the original title of a book in brackets if it is available
  # @return [String] (original title in brackets)
  def original_title(book)
    original = book.original_title
    "(#{original})" if original.present?
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
    cover.attached? ? image_tag(cover.variant(resize_to_limit: [img_size, img_size])) : generate_book_cover_svg(css_tag)
  end
  # rubocop:enable Metrics/MethodLength

  # returns span tags with filled stars equal to the rating and empty stars to fill up to 5
  # @return [String] (HTML span tags)
  def rating_stars(rating)
    content_tag(:span, class: 'color-accent') do
      (inline_svg_tag('star-filled.svg', class: 'smallicon') * rating) <<
      (inline_svg_tag('star.svg', class: 'smallicon') * (5- rating))
    end
  end

  # Displays the book synopsis if it is present
  def book_synopsis(book)
    synopsis = book.synopsis
    # rubocop:disable Rails/Blank
    # (we use synopsis.present here as we test for nil as well)
    return unless synopsis.present?
    # rubocop:enable Rails/Blank
    content_tag(:div, class: 'bookdetails__synopsis') do
      content_tag(:h3, class: 'bookdetails__synposis-title') do
        'Synopsis'
      end <<
      # rubocop:disable Rails:OutputSafety
      # (we use raw(synopsis) here as we need the HTML tags rendered)
      raw(synopsis)
      # rubocop:enable Rails:OutputSafety
    end
  end

  # shows the first <length> characters of the book synopsis.
  # if no length is given, it is set to 100
  def trunc_synopsis(book, characters = 100)
    truncate(strip_tags(book.synopsis.to_s), length: characters)
  end

  private

  # generates a SVG tag with the given class
  def generate_book_cover_svg(css)
    inline_svg_tag('book.svg', class: css)
  end

end
