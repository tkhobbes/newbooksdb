# frozen_string_literal: true

module Google
  class BookSearch
    attr_accessor :isbn, :search_results

    BASE_URL = 'https://www.googleapis.com/books/v1/volumes?q=isbn:'

    def initialize(isbn)
      @isbn = normalize_isbn(isbn)
      @search_results = []
    end

    def search_data
      jsondoc = JSON.parse(URI.open(get_url).read, symbolize_names: true)
      return @search_results if jsondoc.dig(:totalItems) == 0
      jsondoc.dig(:items).each do |item|
        @search_results << create_item(item)
      end
      @search_results
    end

    private

    def normalize_isbn(isbn)
      isbn.gsub!(/-/, '')
    end

    def get_url
      "#{BASE_URL}#{isbn}#{add_key}"
    end

    def add_key
      "&key=#{Rails.application.credentials.google.api}"
    end

    def create_item(found_item)
      item = {}
      item[:source_id] = found_item.dig(:id)
      item[:title] = found_item.dig(:volumeInfo, :title)
      item[:image_url] = found_item.dig(:volumeInfo, :imageLinks, :thumbnail)
      return item
    end
  end
end
