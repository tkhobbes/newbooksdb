# frozen_string_literal: true

# standard Rails controller for the books model
class GenresController < ApplicationController

  # list all genres and the first books within each genre
  def index
    @genres = Genre.includes([:books_genres]).includes([:books])
  end
end
