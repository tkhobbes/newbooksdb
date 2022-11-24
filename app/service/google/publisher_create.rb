# frozen_string_literal: true

module Google
  #service object to create publisher from google api response
  class PublisherCreate
    attr_accessor :publisher_name

    def initialize(name)
      @publisher_name = name
    end

    def create_publisher
      if Publisher.exists?(name: @publisher_name)
        Publisher.find_by(name: @publisher_name)
      else
        Publisher.create(name: @publisher_name)
      end
    end

  end
end
