# frozen_string_literal: true

# standard Rails controller for the books model
class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # delete backlinks stack on book show page
  before_action :dissolve, only: [:show]

  # standard index method - show all books
  # books ordered by sort_title; additional variable @pagy for pagination
  def index
    @pagy, @books = pagy(Book.includes([cover_attachment: :blob]).includes([:rich_text_synopsis]).order(:sort_title))
  end

  # Standard show method - show book details
  def show; end

  # standard new method - show form for new book
  def new
    @book = Book.new
  end

  # creation / storage of a new book
  def create
    @book = Book.new(book_params)

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
      format.html { redirect_to books_path, alert: 'Book removed', status: :see_other }
    end
  end

  private

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
      :synopsis
    )
  end
  # rubocop:enable Metrics/MethodLength
end
