# frozen_string_literal: true

module Google
  # service object to create author from google api response
  class AuthorCreate

    # accepts authors - which could be an array or a string
    # we set the author to the first name in the array if it is an array
    # this method smells of :reek:FeatureEnvy
    def initialize(authors)
      @author = authors.is_a?(Array) ? authors.first : authors
    end

    # this method smells of :reek:DuplicateMethodCall
    # this method smells of :reek:FeatureEnvy
    def create_author
      split = @author.split
      if Author.exists?(first_name: split.first, last_name: split.last)
        Author.find_by(first_name: split.first, last_name: split.last)
      else
        author = Author.create(first_name: split.first, last_name: split.last)
        PictureAttacher.new(retrieve_picture_for(@author), author.portrait).attach
        author
      end
    end

    private

    def retrieve_picture_for(author)
      url = "https://www.mediawiki.org/w/api.php?action=query&titles=#{image_file_name(author)}&prop=imageinfo&iiprop=url&format=json"
      json_doc = JSON.parse(Faraday.get(url).body, symbolize_names: true)
      return unless json_doc
      urls = json_doc.dig(:query, :pages, :"-1", :imageinfo)
      return unless urls
      urls.first[:url]
    end

    def image_file_name(author)
      all_images = search_author_in_wiki(author)
      if all_images
        all_images.select { |i| i[-3,3] == 'jpg' || i[-3,3] == 'png' }.first&.gsub(' ', '%20')
      end
    end

    def search_author_in_wiki(author)
      wiki = MediaWiki::Butt.new('https://en.wikipedia.org/w/api.php')
      wiki.get_images_in_page(author) # returns nil if page is not found
    end
  end
end
