# frozen_string_literal: true

class SearchController < ApplicationController
  # delete backlinks stack on book show page
  before_action :dissolve

  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  # method to respond to quicksearch menu form
  # rubocop:disable Layout/LineLength
  # This Method smells of :reek:DuplicateMethodCall
  # This method smells of :reek:TooManyStatements
  def quicksearch
    @results = params[:query] ? Book.search(params[:query]) + Author.search(params[:query], default_operator: :or) : []
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace('quicksearch_results', partial: 'search/quicksearchresults') }
    end
  end
  # rubocop:enable Layout/LineLength

  # we use the index method for search results
  # This Method smells of :reek:DuplicateMethodCall
  def index
    book_results = []
    book_results = Book.search(params[:query])
      .includes([:author, :owner, cover_attachment: :blob]) if params[:query]
    @pagy, @books = pagy(book_results)
    author_results = []
    author_results = Author.search(params[:query], default_operator: :or)
    @pagy_authors, @authors = pagy(author_results)
  end

end
