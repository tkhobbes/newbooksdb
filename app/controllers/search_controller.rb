# frozen_string_literal: true

class SearchController < ApplicationController
  # delete backlinks stack on book show page
  before_action :dissolve

  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  # method to respond to quicksearch menu form
  def quicksearch
    @results_books = params[:query] ? Book.search(params[:query]) : []
    respond_to do |format|
      format.html {}
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace('quicksearch_results', partial: 'search/quicksearchresults')
      }
    end
  end

  # we use the index method for search results
  def index
    book_results = params[:query] ? Book.search(params[:query])
     .includes([:author, :user, cover_attachment: :blob]) : []
    @pagy, @books = pagy(book_results)
  end

end
