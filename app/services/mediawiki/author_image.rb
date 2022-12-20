# frozen_string_literal: true

module Mediawiki

  # this service object retrieves the URL of an author from Mediawiki
  class AuthorImage

    def wiki_picture(author)
      retrieve_picture_for(author)
    end

    private

    def retrieve_picture_for(author)
      url = "https://www.mediawiki.org/w/api.php?action=query&titles=#{image_file_name(author)}&prop=imageinfo&iiprop=url&format=json"
      json_doc = JSON.parse(Faraday.get(url).body, symbolize_names: true)
      return unless json_doc
      urls = json_doc.dig(:query, :pages, :'-1', :imageinfo)
      return unless urls
      urls.first[:url]
    end

    def image_file_name(author)
      all_images = search_author_in_wiki(author)
      return unless all_images
      all_images.detect { |i| i[-3,3] == 'jpg' || i[-3,3] == 'png' }
        .gsub(' ', '%20')
    end

    def search_author_in_wiki(author)
      wiki = MediaWiki::Butt.new('https://en.wikipedia.org/w/api.php')
      wiki.get_images_in_page(author) # returns nil if page is not found
    end
  end
end