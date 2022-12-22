# frozen_string_literal: true

module Google
  # this service object searches for books and gives back an array of book items
  # this class smells of :reek:RepeatedConditional
  class BookSearch

    BASE_URL = 'https://www.googleapis.com/books/v1/volumes?'
    ISBN_ADDER = 'q=isbn:'
    TITLE_ADDER = 'q=intitle:'
    AUTHOR_ADDER = 'q=inauthor:'
    MAXQ_ADDER = '&maxResults=40'

    # this method smells of :reek:ControlParameter
    def initialize(type, value)
      @isbn = normalize_isbn(value) if type == 'isbn'
      @title = value if type == 'title'
      @author = value if type == 'author'
      @search_results = []
    end

    def search_isbn
      jsondoc = JSON.parse(Faraday.get(parse_isbn_url).body, symbolize_names: true)
      return @search_results if jsondoc[:totalItems].zero?
      jsondoc[:items].each do |item|
        @search_results << create_item(item)
      end
      @search_results
    end

    def search_title
      jsondoc = JSON.parse(Faraday.get(parse_title_url).body, symbolize_names: true)
      return @search_results if jsondoc[:totalItems].zero?
      jsondoc[:items].each do |item|
        @search_results << create_item(item)
      end
      @search_results
    end

    def search_author
      jsondoc = JSON.parse(Faraday.get(parse_author_url).body, symbolize_names: true)
      return @search_results if jsondoc[:totalItems].zero?
      jsondoc[:items].each do |item|
        @search_results << create_item(item)
      end
      @search_results
    end

    private

    # this method smells of :reek:UtilityFunction
    def normalize_isbn(isbn)
      isbn.delete!(/-/)
    end

    def parse_isbn_url
      "#{BASE_URL}#{ISBN_ADDER}#{@isbn}#{add_key}#{MAXQ_ADDER}"
    end

    def parse_title_url
      "#{BASE_URL}#{TITLE_ADDER}#{@title}#{add_key}#{MAXQ_ADDER}"
    end

    def parse_author_url
      "#{BASE_URL}#{AUTHOR_ADDER}#{@author}#{add_key}#{MAXQ_ADDER}"
    end

    # this method smells of :reek:UtilityFunction
    def add_key
      "&key=#{Rails.application.credentials.google.api}"
    end

    # this method smells of :reek:UtilityFunction
    def create_item(found_item)
      item = {}
      item[:identifier] = found_item[:id]
      item[:existing] = Book.exists?(identifier: item[:identifier])
      item[:title] = found_item.dig(:volumeInfo, :title)
      item[:image_url] = found_item.dig(:volumeInfo, :imageLinks, :thumbnail)
      item
    end
  end
end
