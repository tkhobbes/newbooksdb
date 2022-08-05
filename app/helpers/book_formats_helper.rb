# frozen_string_literal: true

module BookFormatsHelper

  # displays "(default)" if format is defined as fallback
  def is_fallback(book_format)
    " (default)" if book_format.fallback?
  end
end
