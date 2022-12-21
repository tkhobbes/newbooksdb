# frozen_string_literal: true

module Openlibrary
  # this service object searches for covers and gives back a cover url
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
