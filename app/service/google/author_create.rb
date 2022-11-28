# frozen_string_literal: true

module Google
  # service object to create author from google api response
  class AuthorCreate
    attr_accessor :author

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
        Author.create(first_name: split.first, last_name: split.last)
      end
    end

  end
end
