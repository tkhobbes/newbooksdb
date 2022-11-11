# frozen_string_literal: true

# A simple controller to control the flow to search for an ISBN
class IsbnSearchController < ApplicationController

  # display a form
  def new

  end

  # show the results
  def show
    @results = Amazon.new(params[:isbn]).scrape_page
  end
end
