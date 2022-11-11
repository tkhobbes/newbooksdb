# frozen_string_literal: true

# This service class deals with scraping data from amazon
class Amazon
  attr_accessor :isbn, :search_results

  def initialize(input_isbn)
    @isbn = normalize_isbn(input_isbn)
    @search_results = []
  end

  def scrape_page
    items = select_amazon_results(crawl_page.css('[data-component-type="s-search-results"] [data-asin]'))
    items.each do |found_item|
      item = {}
      item[:ASIN] = found_item.attributes['data-asin'].value
      item[:title] = found_item.css('h2').text
      item[:image_url] = found_item.css('img').first['srcset'].split(', ').last.split(' ').first
      item[:url] = ''
      puts "----------"
      @search_results << item
    end
    @search_results
  end

  private

  def normalize_isbn(isbn)
    isbn.gsub!(/-/, '')
  end

  def get_url
    url_base = 'https://www.amazon.de/s?k='
    "#{url_base}#{@isbn}"
  end

  def crawl_page
    MetaInspector.new(get_url).parsed
  end

  def select_amazon_results(results)
    results.select{ |r| r['data-asin'] != nil && r['data-asin'] != '' }
  end

end
