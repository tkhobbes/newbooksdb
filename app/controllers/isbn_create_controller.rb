# frozen_string_literal: true

# This controller deals with creating books from an ISBN search
class IsbnCreateController < ApplicationController

  # create a book based on an ISBN / URL
  # this method smells of :reek:DuplicateMethodCall
  def create
    # use params[:identifier] to determine the Amazon URL
    result = Google::BookCreate.new(params[:identifier], current_owner).create_book
    if result.created?
      redirect_to book_path(result.book), notice: result.message
    else
      redirect_to root_path, error: result.message
    end
  end
end
