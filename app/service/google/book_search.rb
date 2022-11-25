# frozen_string_literal: true

module Google
  class BookSearch
    attr_accessor :isbn, :title, :author, :search_results

    BASE_URL = 'https://www.googleapis.com/books/v1/volumes?'
    ISBN_ADDER = 'q=isbn:'
    TITLE_ADDER = 'q=intitle:'
    AUTHOR_ADDER = 'q=inauthor:'

    def initialize(type, value)
      @isbn = normalize_isbn(value) if type == 'isbn'
      @title = value if type == 'title'
      @author = value if type == 'author'
      @search_results = []
    end

    def search_isbn
      jsondoc = JSON.parse(URI.open(get_isbn_url).read, symbolize_names: true)
      return @search_results if jsondoc.dig(:totalItems) == 0
      jsondoc.dig(:items).each do |item|
        @search_results << create_item(item)
      end
      @search_results
    end

    def search_title
      jsondoc = JSON.parse(URI.open(get_title_url).read, symbolize_names: true)
      return @search_results if jsondoc.dig(:totalItems) == 0
      jsondoc.dig(:items).each do |item|
        @search_results << create_item(item)
      end
      @search_results
    end

    def search_author
      jsondoc = JSON.parse(URI.open(get_author_url).read, symbolize_names: true)
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

    def get_isbn_url
      "#{BASE_URL}#{ISBN_ADDER}#{@isbn}#{add_key}"
    end

    def get_title_url
      "#{BASE_URL}#{TITLE_ADDER}#{@title}#{add_key}"
    end

    def get_author_url
      "#{BASE_URL}#{AUTHOR_ADDER}#{@author}#{add_key}"
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
