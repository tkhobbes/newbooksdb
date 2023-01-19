# frozen_string_literal: true

# This service class deals with scraping data from amazon and creating an author
# it returns the author object which is saved to the database, if not possible, nil
# rubocop:disable all
module Amazon
  class AuthorCreate
    attr_accessor :author_url

    BASE_URL = 'https://www.amazon.de'

    def initialize(link)
      @author_url = get_author_url(link)
    end

    def create_author
      return if @author_url == BASE_URL
      author_data = get_author_data(crawl_author_page)
      return unless author_data[:first_name] || author_data[:last_name]
      exist_data = {}
      exist_data[:first_name] = author_data[:first_name]
      exist_data[:last_name] = author_data[:last_name]
      if Author.exists?(exist_data)
        author = Author.find_by(exist_data)
      else
        author = Author.create(exist_data)
        # attach picture
        if author
          result = PictureAttacher.new(author_data[:portrait_url], author.portrait).attach
        end
      end
      return author
    end

    private

    def get_author_url(link)
      "#{BASE_URL}#{link}"
    end

    def crawl_author_page
      MetaInspector.new(@author_url, :headers => {
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:10.0) Gecko/20100101 Firefox/10.0'
      }).parsed
    end

    def get_author_data(author_results)
      author_data = {}
      author_data[:first_name] = get_author_first_name(author_results)
      author_data[:last_name] = get_author_last_name(author_results)
      author_data[:portrait_url] = get_author_portrait_url(author_results)
      author_data
    end

    def get_author_first_name(result)
      result.css('#authorName h1').text.strip.split(' ').first if result.css('#authorName h1')
    end

    def get_author_last_name(result)
      result.css('#authorName h1').text.strip.split(' ').last if result.css('#authorName h1')
    end

    def get_author_portrait_url(result)
      result.css('#authorImage img').first['src'] if result.css('#authorImage img')
    end
  end
end
# rubocop:enable all
