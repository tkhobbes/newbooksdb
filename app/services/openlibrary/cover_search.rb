# frozen_string_literal: true

module Openlibrary
  class CoverSearch

    BASE_URL = 'https://covers.openlibrary.org/b/'
    COVER_SIZE = 'L'

    def initialize(isbn:, type: 'isbn')
      @type = type
      @isbn = isbn
    end

    def cover_url
      "#{BASE_URL}#{@type}/#{@isbn}-#{COVER_SIZE}.jpg"
    end

  end
end
