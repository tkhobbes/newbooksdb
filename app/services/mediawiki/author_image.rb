# frozen_string_literal: true

module Mediawiki

  # this service object retrieves the URL of an author from Mediawiki
  class AuthorImage

    def wiki_picture(author)
      retrieve_picture_for(author)
    end

    private

    # this method smells of :reek:TooManyStatements
    def retrieve_picture_for(author)
      url = "https://www.mediawiki.org/w/api.php?action=query&titles=#{image_file_name(author)}&prop=imageinfo&iiprop=url&format=json"
      json_doc = JSON.parse(Faraday.get(url).body, symbolize_names: true)
      return unless json_doc
      urls = json_doc.dig(:query, :pages, :'-1', :imageinfo)
      return unless urls
      urls.first[:url]
    end

    # this method smells of :reek:DuplicateMethodCall
    # this method smells of :reek:FeatureEnvy
    # this method smells of :reek:UncommunicativeVariableName
    # this method smells of :reek:TooManyStatements
    def image_file_name(author)
      all_images = search_author_in_wiki(author)
      return unless all_images
      image = all_images.detect { |i| i[-3,3] == 'jpg' || i[-3,3] == 'png' }
      return unless image
      image.gsub(' ', '%20')
    end

    # this method smells of :reek:UtilityFunction
    def search_author_in_wiki(author)
      wiki = MediaWiki::Butt.new('https://en.wikipedia.org/w/api.php')
      wiki.get_images_in_page(author) # returns nil if page is not found
    end
  end
end
