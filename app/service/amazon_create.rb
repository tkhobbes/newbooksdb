# frozen_string_literal: true

# This service class deals with scraping data from amazon and creating a book
# it returns the book object which is saved to the database
class AmazonCreate
  attr_accessor :asin, :book_data, :final_message

  BASE_URL = 'https://www.amazon.de'

  def initialize(asin)
    @asin = asin
    @book_data = {}
    @final_message = ''
  end

  def create_book
    book_results = crawl_book_page
    @book_data[:title] = get_book_title(book_results)
    @book_data[:year] = get_book_year(book_results)
    @book_data[:edition] = get_book_edition(book_results)
    @book_data[:pages] = get_book_pages(book_results)
    @book_data[:isbn] = get_book_isbn(book_results)
    @book_data[:book_format] = BookFormat.find_by(fallback: true)

    # author object returned that is already saved to the database or NIL if no author could be created
    author = AmazonAuthorCreate.new(get_author_link(book_results)).create_author
    @final_message << 'Author could not be created. ' unless author

    # publisher
    # puts result.css('#rpi-attribute-book_details-publisher .rpi-attribute-value').text.strip
    # image
    # puts result.css('#img-canvas img').first['src']

    # - also creates the publisher
    # - creates the genres
    # - attaches the image
  end

  private

  def get_book_url
    "#{BASE_URL}/dp/#{@asin}"
  end

  def crawl_book_page
    MetaInspector.new(get_book_url).parsed
  end

  def get_book_title(result)
    result.css('#productTitle').text.strip
  end

  def get_book_year(result)
    result.css('#rpi-attribute-book_details-publication_date .rpi-attribute-value').text.strip[-4,4]
  end

  def get_book_edition(result)
    result.css('#detailBullets_feature_div li').first.text.split(';').last.split('(').first.strip
  end

  def get_book_pages(result)
    result.css('#rpi-attribute-book_details-fiona_pages .rpi-attribute-value').text.split(' ').first.strip
  end

  def get_book_isbn(result)
    result.css('#rpi-attribute-book_details-isbn13 .rpi-attribute-value').text.strip
  end

  def get_author_link(result)
    result.css('#bylineInfo .author a.contributorNameID').first['href']
  end


end
