# frozen_string_literal: true

module Google
  # service object to create a book from the google API
  class BookCreate
    attr_accessor :id, :owner, :json_data

    BASE_URL = 'https://www.googleapis.com/books/v1/volumes/'

    def initialize(id, owner)
      @id = id # the unique ID as per Google API
      @owner = owner # typically the currently logged in owner
      @json_data = {}
    end

    # returns a book object if created or nil, and a message
    # this method smells of :reek:TooManyStatements
    def create_book
      @json_data = fetch_json_data
      return nil, 'Something went wrong at the backend.' if @json_data.empty?
      return nil, 'Book already exists.' if Book.exists?(title: @json_data.dig(:volumeInfo, :title), owner: @owner)
      author = Google::AuthorCreate.new(@json_data.dig(:volumeInfo, :authors)).create_author
      publisher = Google::PublisherCreate.new(@json_data.dig(:volumeInfo, :publisher)).create_publisher
      book = Book.create(fetch_book_data.merge(author:, publisher:))
      [nil, 'Something went wrong while saving the book.'] unless book
      PictureAttacher.new(parse_cover_url, book.cover).attach
      [book, 'Book created.']
    end

    private

    # returns a json document of the google book api data
    def fetch_json_data
      JSON.parse(Faraday.get(parse_url).body, symbolize_names: true)
    rescue Faraday::ConnectionFailed
      nil
    end

    def fetch_book_data
      {
        title: @json_data.dig(:volumeInfo, :title),
        year: parse_year(@json_data.dig(:volumeInfo, :publishedDate)),
        pages: @json_data.dig(:volumeInfo, :pageCount),
        isbn: parse_isbn13 || parse_isbn10,
        synopsis: @json_data.dig(:volumeInfo, :description),
        source_id: @json_data[:id],
        book_format: BookFormat.find_by(fallback: true),
        owner: @owner
      }
    end

    # this method smells of :reek:UtilityFunction
    def parse_year(data)
      data[0..3].to_i if data && data.size >= 4
    end

    # rubocop:disable Style/BlockDelimiters
    # This method smells of :reek:UncommunicativeMethodName
    def parse_isbn13
      @json_data.dig(:volumeInfo, :industryIdentifiers).find {
        |hash| hash.value?('ISBN_13')
      }[:identifier]
    end

    # this method smells of :reek:UncommunicativeMethodName
    def parse_isbn10
      @json_data.dig(:volumeInfo, :industryIdentifiers).find {
        |hash| hash.values?('ISBN_10')
      }[:identifier]
    end
    # rubocop:enable Style/BlockDelimiters

    def parse_cover_url
      @json_data.dig(:volumeInfo, :imageLinks, :medium) ||
        @json_data.dig(:volumeInfo, :imageLinks, :small) ||
        @json_data.dig(:volumeInfo, :imageLinks, :thumbnail)
    end

    def parse_url
      "#{BASE_URL}#{id}#{add_key}"
    end

    # this method smells of :reek:UtilityFunction
    def add_key
      "?key=#{Rails.application.credentials.google.api}"
    end

  end
end
