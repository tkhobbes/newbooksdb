# frozen_string_literal: true

module Google
  # this service object searches for books and gives back an array of book items
  # this class smells of :reek:RepeatedConditional
  # this class smells of :reek:TooManyInstanceVariables
  class BookSearch

    include Google::ParseIsbn

    BASE_URL = 'https://www.googleapis.com/books/v1/volumes?'
    ISBN_ADDER = 'q=isbn:'
    TITLE_ADDER = 'q=intitle:'
    AUTHOR_ADDER = 'q=inauthor:'
    MAXQ_ADDER = '&maxResults=40'

    # this method smells of :reek:ControlParameter
    def initialize(value:, owner:, type: 'isbn')
      @isbn = normalize_isbn(value) if type == 'isbn'
      @title = value if type == 'title'
      @author = value if type == 'author'
      @owner = owner
      @search_results = []
    end

    def search_isbn
      jsondoc = JSON.parse(Faraday.get(parse_isbn_url).body, symbolize_names: true)
      return @search_results if jsondoc[:totalItems].zero?
      jsondoc[:items].each do |item|
        @search_results << create_item(item, isbn_owners)
      end
      @search_results
    end

    def search_title
      jsondoc = JSON.parse(Faraday.get(parse_title_url).body, symbolize_names: true)
      return @search_results if jsondoc[:totalItems].zero?
      jsondoc[:items].each do |item|
        @search_results << create_item(item, isbn_owners)
      end
      @search_results
    end

    def search_author
      jsondoc = JSON.parse(Faraday.get(parse_author_url).body, symbolize_names: true)
      return @search_results if jsondoc[:totalItems].zero?
      jsondoc[:items].each do |item|
        @search_results << create_item(item, isbn_owners)
      end
      @search_results
    end

    private

    # this method smells of :reek:UtilityFunction
    def normalize_isbn(isbn)
      isbn.delete('-')
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
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    # this method smells of :reek:DuplicateMethodCall
    # this method smells of :reek:FeatureEnvy
    # this method smells of :reek:TooManyStatements
    def create_item(found_item, book_list)
      item = {}
      item[:identifier] = found_item[:id]
      item[:isbn] = parse_isbn13(found_item) || parse_isbn10(found_item)
      item[:existing] = if
        book_list.find { |book| book[0] == item[:isbn] && book[1] == @owner.id }
          'current_owner'
        elsif book_list.find { |book| book[0] == item[:isbn] }
          'other_owner'
        end
      item[:title] = found_item.dig(:volumeInfo, :title)
      item[:image_url] = found_item.dig(:volumeInfo, :imageLinks, :thumbnail)
      item
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    # method returns an array of all ISBNs and Owners
    # this method smells of :reek:UtilityFunction
    def isbn_owners
      Book.all.pluck(:isbn, :owner_id)
    end
  end
end
