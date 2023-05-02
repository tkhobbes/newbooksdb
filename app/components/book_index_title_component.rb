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

  # this method smells of :reek:DuplicateMethodCall
  def letter
    @params[:letter] ? " #{t('BookIndexTitleComponent.starting_with', letter: @params[:letter].upcase)}" : ''
  end

  # this method smells of :reek:DuplicateMethodCall
  def shelf
    if @params[:my_books]
      t('BookIndexTitleComponent.my_books')
    elsif @params[:shelf_books]
      t('BookIndexTitleComponent.in_shelf', shelf: Shelf.find(@params[:shelf_books]).name)
    elsif @params[:no_shelf]
      t('BookIndexTitleComponent.no_shelf')
    else
      t('BookIndexTitleComponent.all_books')
    end
  end

end
