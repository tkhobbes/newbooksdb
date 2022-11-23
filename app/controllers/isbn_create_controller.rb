# frozen_string_literal: true

# This controller deals with creating books from an ISBN search
class IsbnCreateController < ApplicationController

  # create a book based on an ISBN / URL
  def create
    # use params[:identifier] to determine the Amazon URL
    book, message = AmazonCreate.new(params[:identifier], current_owner).create_book
    if book
      redirect_to book_path(book), notice: message
    else
      redirect_to root_path, error: message
    end
  end
end
