# frozen_string_literal: true

# A simple controller to control the flow to search for an ISBN
class IsbnSearchController < ApplicationController

  # show the results
  #rubocop:disable Metrics/AbcSize
  # this method smells of :reek:DuplicateMethodCall
  def show
    #@results = AmazonSearch.new(params[:isbn]).scrape_page
    @results = if params[:isbn]
      Google::BookSearch.new(value: params[:isbn], owner: current_owner).search_isbn
    elsif params[:title]
      @results = Google::BookSearch.new(type: 'title', value: params[:title], owner: current_owner).search_title
    elsif params[:author]
      @results = Google::BookSearch.new(type: 'author', value: params[:author], owner: current_owner).search_author
    end
  end
  # rubocop:enable Metrics/AbcSize

  # display a form
  def new; end

end
