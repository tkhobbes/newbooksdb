# frozen_string_literal: true

# This controller deals with creating books from an ISBN search
class IsbnCreateController < ApplicationController

  # create a book based on an ISBN / URL
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  # this method smells of :reek:DuplicateMethodCall
  # this method smells of :reek:TooManyStatements
  def create
    # use params[:identifier] to determine the Amazon URL
    result = Google::BookCreate.new(params[:identifier], current_owner).create_book
    respond_to do |format|
      format.html do # this is the response to the manual form search
        if result.created?
          redirect_to book_path(result.book), notice: result.message
        else
          redirect_to root_path, error: result.message
        end
      end
      format.turbo_stream do # response to scan_queues/index.html.erb
        @result = result.book.isbn
        scan_results = Kredis.set current_owner.id.to_s
        scan_results.remove(@result) if scan_results.include? @result
        flash.now[:notice] = result.message
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
