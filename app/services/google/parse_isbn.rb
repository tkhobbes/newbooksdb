# frozen_string_literal: true

# helper methods for different google service classes
module Google
  module ParseIsbn

      # rubocop:disable Style/BlockDelimiters
      # This method smells of :reek:UncommunicativeMethodName
      def parse_isbn13(item)
        item.dig(:volumeInfo, :industryIdentifiers).find {
          |hash| hash.value?('ISBN_13')
        }[:identifier]
      end

      # this method smells of :reek:UncommunicativeMethodName
      def parse_isbn10(item)
        item.dig(:volumeInfo, :industryIdentifiers).find {
          |hash| hash.values?('ISBN_10')
        }[:identifier]
      end
      # rubocop:enable Style/BlockDelimiters

  end
end
