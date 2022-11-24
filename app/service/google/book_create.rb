# frozen_string_literal: true

module Google
  # service object to create a book from the google API
  class BookCreate
    attr_accessor :id, :owner, :json_data

    BASE_URL = 'https://www.googleapis.com/books/v1/volumes/'

    def initialize(id, owner)
      @id = id # the unique ID as per Google API
      @owner = owner # typically the currently logged in owner
    end

    # returns a book object if created or nil, and a message
    def create_book
      @json_data = fetch_json_data(get_url)
      return nil, 'Something went wrong at the backend.' unless @json_data
      return nil, 'Book already exists.' if Book.exists?(title: @json_data.dig(:volumeInfo, :title), owner: @owner)
      author = Google::AuthorCreate.new(@json_data.dig(:volumeInfo, :authors)).create_author
      publisher = Google::PublisherCreate.new(@json_data.dig(:volumeInfo, :publisher)).create_publisher
      book = Book.create(fetch_book_data.merge(author: author, publisher: publisher))
      if book
        PictureAttacher.new(get_cover_url, book.cover).attach
        return book, 'Book created.'
      else
        return nil, 'Something went wrong while saving the book.'
      end
    end

    private

    # returns a json document of the google book api data
    def fetch_json_data(url)
      begin
        jsondoc = JSON.parse(URI.open(get_url).read, symbolize_names: true)
      rescue OpenURI::HTTPError
        return nil
      end
    end

    def fetch_book_data
      {
        title: @json_data.dig(:volumeInfo, :title),
        year: get_year(@json_data.dig(:volumeInfo, :publishedDate)),
        pages: @json_data.dig(:volumeInfo, :pageCount),
        isbn: get_isbn_13 || get_isbn_10,
        synopsis: @json_data.dig(:volumeInfo, :description),
        source_id: @json_data.dig(:id),
        book_format: BookFormat.find_by(fallback: true),
        owner: @owner
      }
    end

    def get_year(data)
      data[0..3].to_i if data && data.size >= 4
    end

    def get_isbn_13
      @json_data.dig(:volumeInfo, :industryIdentifiers).find {
        |hash| hash.values.include?('ISBN_13')
      }[:identifier]
    end

    def get_isbn_10
      @json_data.dig(:volumeInfo, :industryIdentifiers).find {
        |hash| hash.values.include?('ISBN_10')
      }[:identifier]
    end

    def get_cover_url
      @json_data.dig(:volumeInfo, :imageLinks, :small) || @json_data.dig(:volumeInfo, :imageLinks, :thumbnail)
    end

    def get_url
      "#{BASE_URL}#{id}#{add_key}"
    end

    def add_key
      "?key=#{Rails.application.credentials.google.api}"
    end

  end
end
