# frozen_string_literal: false
# we need to reopen the string @final_message for adding comments if something goes wrong

# This service class deals with scraping data from amazon and creating a book
# it returns the book object which is saved to the database
# rubocop:disable all
module Amazon
  class BookCreate
    attr_accessor :asin, :book_data, :final_message, :owner

    BASE_URL = 'https://www.amazon.de'

    def initialize(asin, owner)
      @asin = asin
      @book_data = {}
      @final_message = ''
      @owner = owner
    end

    # returns a book object if successful, nil if not
    def create_book
      @book_data, extra_data = fetch_book_data
      return nil, 'Book already exists. ' unless @book_data
      # service object returns an author object or NIL if no author was found
      author = AmazonAuthorCreate.new(extra_data[:author]).create_author
      author ? @book_data[:author] = author : @final_message << 'Author could not be created. '
      # service object returns a publisher object or NIL if no publisher was found
      publisher = AmazonPublisherCreate.new(extra_data[:publisher]).create_publisher
      publisher ? @book_data[:publisher] = publisher : @final_message << 'Publisher could not be created. '
      # create the book object
      book = Book.create(@book_data)
      if book
        # image
        PictureAttacher.new(get_book_cover(book_results), book.cover).attach
        @final_message << 'Book created. '
        return book, @final_message
      else
        @final_message << 'Something went wrong with the book creation. '
        return nil, @final_message
      end
    end

    private

    def fetch_book_data
      book_results = crawl_book_page
      data = Hash.new(title: get_book_title(book_results), owner: @owner)
      debugger
      return nil, nil if Book.exists?(data) || data.empty? || data.nil?
      data.update(
        year: get_book_year(book_results),
        edition: get_book_edition(book_results),
        pages: get_book_pages(book_results),
        isbn: get_book_isbn(book_results),
        book_format: BookFormat.find_by(fallback: true)
      )
      extra = Hash.new(
        author: get_author_link(book_results),
        publisher: get_book_publisher(book_results)
      )
      debugger
      return data, extra
    end

    def crawl_book_page
      MetaInspector.new(get_book_url).parsed
    end

    def get_book_url
      "#{BASE_URL}/dp/#{@asin}"
    end

    def get_book_title(result)
      result.css('#productTitle').text.strip
    end

    def get_book_year(result)
      result.css('#rpi-attribute-book_details-publication_date .rpi-attribute-value').text.strip[-4,4]
    end

    def get_book_edition(result)
      result.css('#detailBullets_feature_div li').first.text.split(';').last.split('(').first.strip if result.css('#detailBullets_feature_div li')
    end

    def get_book_pages(result)
      result.css('#rpi-attribute-book_details-fiona_pages .rpi-attribute-value').text.split(' ').first&.strip
    end

    def get_book_isbn(result)
      result.css('#rpi-attribute-book_details-isbn13 .rpi-attribute-value').text.strip
    end

    def get_author_link(result)
      result.css('#bylineInfo .author a.contributorNameID').first['href'] if result.css('#bylineInfo .author a.contributorNameID')
    end

    def get_book_publisher(result)
      result.css('#rpi-attribute-book_details-publisher .rpi-attribute-value').text.strip
    end

    def get_book_cover(result)
      result.css('#imgBlkFront').first['src'] if result.css('#imgBlkFront')
    end
  end
end
# rubocop:enable all
