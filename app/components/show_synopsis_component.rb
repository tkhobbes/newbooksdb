# frozen_string_literal: true

class ShowSynopsisComponent < ViewComponent::Base

  def initialize(book:, type: :full)
    super
    @book = book
    @type = type
  end

  def show_truncated_synopsis
    return if @book.synopsis.blank?
    truncate(strip_tags(@book.synopsis.to_s), length: 100)
  end

end
