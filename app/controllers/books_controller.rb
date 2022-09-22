# frozen_string_literal: true

# standard Rails controller for the books model
class BooksController < ApplicationController
  # we need the session helper and the user concerns to ensure only logged in users can tamper with books
  include SessionsHelper
  include UserConcerns

  # everybody can see index and an individual book, but only logged in users can add / update / delete
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :current_user, only: [:create]

  # standard rails - set instance variable for standard actions
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # delete backlinks stack on book show page
  before_action :dissolve, only: [:show]

  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  # standard index method - show all books
  # books ordered by sort_title; additional variable @pagy for pagination
  def index
    all_books = Book
      .includes([:user, cover_attachment: :blob])
      .order(:sort_title)
    if params[:show] == 'list'
      @pagy, @books = pagy(all_books, items: 20)
    else
      @pagy, @books = pagy(
        all_books
          .includes([:rich_text_synopsis, :books_genres, :genres])
      )
    end
  end

  # Standard show method - show book details
  def show; end

  # standard new method - show form for new book
  def new
    @book = Book.new
  end

  # creation / storage of a new book
  def create
    new_params = update_book_format_param(book_params)
    @book = Book.new(new_params.merge(user_id: @current_user.id))

    if @book.save
      flash[:success] = 'Book saved'
      redirect_to book_path(@book)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # standard edit method - show form for editing book
  def edit; end

  # update of a book
  def update
    if @book.update(book_params)
      flash[:success] = 'Book updated'
      redirect_to @book
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # standard destroy method
  def destroy
    @book.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to books_url, alert: 'Book was successfully destroyed.', status: :see_other }
    end
  end

  private

  # ensure the correct user can edit / update / delete a book
  def correct_user
    return if current_user == Book.friendly.find(params[:id]).user
    redirect_to root_path, status: :see_other, error: "You cannot change or delete other user's books"
  end

  # enable turbo frame variants
  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

  # merges the fallback book format into params if no format specified
    # This method smells of :reek:UtilityFunction
  def update_book_format_param(book_params)
    return book_params if book_params[:book_format_id].present?
    book_params.merge(book_format_id: BookFormat.find_by(fallback: true).id)
  end

  # define an instance variable @book
  def set_book
    @book = Book.friendly.find(params[:id])
  end

  # define allowed parameters
  # rubocop:disable Metrics/MethodLength
  def book_params
    params.require(:book).permit(
      :title,
      :original_title,
      :sort_title,
      :edition,
      :rating,
      :condition,
      :year,
      :cover,
      :synopsis,
      :book_format_id,
      genre_ids: []
    )
  end
  # rubocop:enable Metrics/MethodLength
end
