# frozen_string_literal: true

# standard Rails controller for the books model
class GenresController < ApplicationController
  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  # we need the session helper and the user concerns to ensure only logged in users can tamper with formats
  include SessionsHelper
  include UserConcerns

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  before_action :set_genre, only: [:show, :edit, :update, :destroy]

  # index action can answer to either 'settings' page (to administer genres)
  # or otherwise it will display all genres and the first 5 books within each genre
  def index
    if params[:show] == 'settings'
      @genres = Genre.all.order(:name)
      render 'admin', genres: @genres
    else
      @pagy, @genres = pagy(Genre
        .includes([:books_genres, books: [:user, cover_attachment: :blob]])
        .order(:name))
    end
  end

  # shows a genre in detail and lists all books within that genre
  def show
    @genre = Genre.friendly.find(params[:id])
    @pagy, @books = pagy(@genre.books.includes([:user, cover_attachment: :blob]))
  end

  #new action - displayed in a turbo frame within the settings page
  def new
    @genre = Genre.new
  end

  #standard rails create action; answers to:
  # -normal html (fallback and not used)
  # -turbo stream - default response format, used on the settings page
  # -json - used as we can create formats on the fly in the book form
  # This method smells of :reek:DuplicateMethodCall
  # This method smells of :reek:TooManyStatements
  def create
    @genre = Genre.new(genre_params)

    respond_to do |format|
      if @genre.save
        format.turbo_stream
        format.html { redirect_to genre_path(@genre) }
        format.json { render json: @genre }
      else
        format.html { render :new, status: :unprocessable_entity }
      end

    end
  end

  #edit action - displayed in a turbo frame within the settings page
  def edit; end

  #standard rails update action
  def update
    if @genre.update(genre_params)
      redirect_to genres_path(show: 'settings')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  #standard rails destroy action - responds to
  # -html (not used)
  # -turbo-stream - default response format, used on the settings page
  # This method smells of :reek:TooManyStatements
  def destroy
    @genre.destroy
    if @genre.destroyed?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to genres, status: :see_other }
      end
    else
      # in the rare occasion where the format is not deleted -
      # as it is the default - ensure that the corresponding
      # turbo stream is not removed
      render json: { nothing: true }
    end
  end

  # show genres not used
  def unused
    @genres = Genre.no_books.order(:name)
  end

  # removes all actors not in a movie
  def remove_unused
    Genre.no_books.destroy_all
    redirect_to bulk_actions_settings_path, notice: 'Unused Genres removed.'
  end

  private

  def set_genre
    @genre = Genre.friendly.find(params[:id])
  end

  def genre_params
    params.require(:genre).permit(:name)
  end

  # enable turbo frame variants
  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end
end