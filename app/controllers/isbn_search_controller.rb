# frozen_string_literal: true

# A simple controller to control the flow to search for an ISBN
class IsbnSearchController < ApplicationController

  # display a form
  def new; end

  # show the results
  #rubocop:disable Metrics/AbcSize
  # this method smells of :reek:DuplicateMethodCall
  def show
    #@results = AmazonSearch.new(params[:isbn]).scrape_page
    @results = Google::BookSearch.new('isbn', params[:isbn]).search_isbn if params[:isbn]
    @results = Google::BookSearch.new('title', params[:title]).search_title if params[:title]
    @results = Google::BookSearch.new('author', params[:author]).search_author if params[:author]
  end
  # rubocop:enable Metrics/AbcSize
end
