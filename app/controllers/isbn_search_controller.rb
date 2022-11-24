# frozen_string_literal: true

# A simple controller to control the flow to search for an ISBN
class IsbnSearchController < ApplicationController

  # display a form
  def new

  end

  # show the results
  def show
    #@results = AmazonSearch.new(params[:isbn]).scrape_page
    @results = Google::BookSearch.new(params[:isbn]).search_data
  end
end
