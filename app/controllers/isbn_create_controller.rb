# frozen_string_literal: true

# This controller deals with creating books from an ISBN search
class IsbnCreateController < ApplicationController

  # create a book based on an ISBN / URL
  def create
    # use params[:identifier] to determine the Amazon URL
    book = AmazonCreate.new(params[:identifier]).create_book
    if book
      redirect_to book_path(book)
    else
      redirect_to root_path, error: 'Book could not be created'
    end
  end
end
