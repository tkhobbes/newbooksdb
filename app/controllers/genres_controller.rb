# frozen_string_literal: true

# standard Rails controller for the books model
class GenresController < ApplicationController

  # list all genres and the first 5 books within each genre
  def index
    @genres = Genre
      .includes([:books_genres, books: [:user, cover_attachment: :blob]])
      .order(:name)
  end

  # shows a genre in detail and lists all books within that genre
  def show
    @genre = Genre.includes([books: [:user, cover_attachment: :blob]]).find(params[:id])
  end

  private

  def set_genre
    @genre = Genre.find(params[:id])
  end
end
