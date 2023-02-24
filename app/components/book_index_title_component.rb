# frozen_string_literal: true

# component to create the actual title on the book index page dynamically
class BookIndexTitleComponent < ViewComponent::Base

  def initialize(params:)
    super
    @params = params
  end

  # sets the title to display on the index page for books, depending on what we see
  # this method smells of :reek:DuplicateMethodCall
  def book_index_title
    "#{shelf}#{letter}"
  end

  private

  def letter
    @params[:letter] ? " starting with #{@params[:letter].upcase}" : ''
  end

  def shelf
    if @params[:my_books]
      'My Books'
    elsif @params[:shelf_books]
      "Books in Shelf '#{Shelf.find(@params[:shelf_books]).name}'"
    elsif @params[:no_shelf]
      'Books in no Shelf'
    else
      'All Books'
    end
  end

end
