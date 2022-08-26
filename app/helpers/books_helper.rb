# frozen_string_literal: true

# Book Helper module includes various view helpers
module BooksHelper

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
  # rubocop:disable Metrics/MethodLength
  def rating_stars(rating)
    content_tag(:span, class: 'color-accent') do
      (content_tag(
        :svg,
        xlmns: 'http://www.w3.org/2000/svg',
        class: 'smallicon',
        viewBox: '0 0 24 24',
        fill: 'currentColor',
        stroke: 'currentColor',
        # rubocop:disable Layout/LineLength
        'stroke-width': '1') do
          tag.path(d: 'M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z')
        # rubocop:enable Layout/LineLength
      end * rating) <<
      (content_tag(
        :svg,
        xmlns: 'http://www.w3.org/2000/svg',
        class: 'smallicon',
        fill: 'none',
        viewBox: '0 0 24 24',
        stroke: 'currentColor',
        'stroke-width': '1') do
          # rubocop:disable Layout/LineLength
          tag.path('stroke-linecap': 'round',
            'stroke-linejoin': 'round',
            d: 'M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z')
            # rubocop:enable Layout/LineLength
        end * (5- rating))
    end
  end
  # rubocop:enable Metrics/MethodLength

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
  # rubocop:disable Metrics/MethodLength
  def generate_book_cover_svg(css)
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
        d: 'M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253')
        # rubocop:enable Layout/LineLength
    end
  end
  # rubocop:enable Metrics/MethodLength

end
