# frozen_string_literal: true

# service class to create a publisher object
# rubocop:disable all
module Amazon
  class AmazonPublisherCreate
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def create_publisher
      return unless @name || name != ''
      publisher_data = {}
      publisher_data[:name] = @name
      if Publisher.exists?(publisher_data)
        publisher = Publisher.find_by(publisher_data)
      else
        publisher = Publisher.create(publisher_data)
      end
      return publisher
    end
  end
end
# rubocop:enable all
