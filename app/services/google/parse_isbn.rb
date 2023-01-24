# frozen_string_literal: true

module Google
  # helper methods for different google service classes
  module ParseIsbn

      # rubocop:disable Style/BlockDelimiters
      # This method smells of :reek:UncommunicativeMethodName
      # this method smells of :reek:IrresponsibleModule
      # this method smells of :reek:UtilityFunction
      def parse_isbn13(item)
        item.dig(:volumeInfo, :industryIdentifiers).find {
          |hash| hash.value?('ISBN_13')
        }&.dig(:identifier)
      end

      # this method smells of :reek:UncommunicativeMethodName
      # this method smells of :reek:IrresponsibleModule
      # this method smells of :reek:UtilityFunction
      def parse_isbn10(item)
        item.dig(:volumeInfo, :industryIdentifiers).find {
          |hash| hash.value?('ISBN_10')
        }&.dig(:identifier)
      end
      # rubocop:enable Style/BlockDelimiters

  end
end
