# frozen_string_literal: true

module Openlibrary
  class CoverSearch

    BASE_URL = 'https://covers.openlibrary.org/b/'
    COVER_SIZE = 'L'

    def initialize(value:, type: 'isbn')
      @type = type
      @value = value
    end

    def cover_url
      "#{BASE_URL}#{@type}/#{@value}-#{COVER_SIZE}.jpg"
    end

  end
end
