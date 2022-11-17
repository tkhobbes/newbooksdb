# frozen_string_literal: true

# This service class deals with scraping data from amazon and creating a book
class AmazonCreate
  attr_accessor :asin

  def initialize(asin)
    @asin = asin
    book_data = {}
  end

  def create_book
    results = crawl_page
    debugger
    # - also creates the publisher
    # - also creates the author
    # - sets the book format to default
    # - creates the genres
    # - sets the shelf to no shelf
    # - attaches the image
  end

  private

  def get_url
    url_base = 'https://www.amazon.de/dp/'
    "#{url_base}#{@asin}"
  end

  def crawl_page
    MetaInspector.new(get_url).parsed
  end

end
