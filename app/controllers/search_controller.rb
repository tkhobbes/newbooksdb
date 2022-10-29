# frozen_string_literal: true

class SearchController < ApplicationController

  # method to respond to quicksearch menu form
  def quicksearch
    @books = params[:query] ? Book.where('title LIKE ?', "%#{params[:query]}%") : []
    respond_to do |format|
      format.html {}
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace('quicksearch_results', partial: 'search/quicksearchresults')
      }
    end
  end

  # we use the index method for search results
  def index

  end

end
