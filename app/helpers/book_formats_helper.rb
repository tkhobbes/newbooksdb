# frozen_string_literal: true

# book format helper module, includes various book format methods

module BookFormatsHelper

  # displays "(default)" if format is defined as fallback
  def print_fallback(book_format)
    ' (default)' if book_format.fallback?
  end
end
