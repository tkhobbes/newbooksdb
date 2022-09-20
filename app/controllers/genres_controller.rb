# frozen_string_literal: true

# standard Rails controller for the books model
class GenresController < ApplicationController
  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  # list all genres and the first 5 books within each genre
  def index
    @pagy, @genres = pagy(Genre
      .includes([:books_genres, books: [:user, cover_attachment: :blob]])
      .order(:name))
  end

  # shows a genre in detail and lists all books within that genre
  def show
    @genre = Genre.find(params[:id])
    @pagy, @books = pagy(@genre.books.includes([:user, cover_attachment: :blob]))
  end

  private

  def set_genre
    @genre = Genre.find(params[:id])
  end

  # enable turbo frame variants
  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end
end
