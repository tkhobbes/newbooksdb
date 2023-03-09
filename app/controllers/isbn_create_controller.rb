# frozen_string_literal: true

# This controller deals with creating books from an ISBN search
class IsbnCreateController < ApplicationController

  # create a book based on an ISBN / URL
  # this method smells of :reek:DuplicateMethodCall
  def create
    # use params[:identifier] to determine the Amazon URL
    result = Google::BookCreate.new(params[:identifier], current_owner).create_book
    respond_to do |format|
      format.html do
        if result.created?
          redirect_to book_path(result.book), notice: result.message
        else
          redirect_to root_path, error: result.message
        end
      end
      format.turbo_stream do
        @result = ScanQueue.where(isbn: result.book.isbn, owner: current_owner).first.destroy
      end
    end
  end
end
