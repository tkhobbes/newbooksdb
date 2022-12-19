 # frozen_string_literal: true

 # controller to find better portraits
 class PortraitSearchController < ApplicationController

  # show - display search results
  def show
    @results = Openlibrary::PortraitSearch.new(params[:author]).search_portrait
  end
  # new - a new search
  def new

  end
 end
