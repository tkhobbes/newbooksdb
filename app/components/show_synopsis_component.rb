# frozen_string_literal: true

# shows the synopsis - either truncated or full (exact display type determined in view)
class ShowSynopsisComponent < ViewComponent::Base

  def initialize(book:, type: :full)
    super
    @book = book
    @type = type
  end

  # this method smells of :reek:DuplicateMethodCall
  def show_truncated_synopsis
    return if @book.synopsis.blank?
    truncate(strip_tags(@book.synopsis.to_s), length: 100)
  end

end
