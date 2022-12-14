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
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def index
    return if params[:query].size.zero?
    case params[:list]
    when 'books'
      book_results = Book.search(params[:query])
        .includes([:author, :owner, cover_attachment: :blob])
      @pagy, @books = pagy(book_results)
    when 'authors'
      author_results = Author.search(params[:query], default_operator: :or)
        .includes([portrait_attachment: :blob])
      @pagy_authors, @authors = pagy(author_results)
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

end
