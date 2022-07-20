# standard Rails controller for the books model
class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # standard index method - show all books
  def index
    @books = Book.includes([cover_attachment: :blob]).order(:sort_title).limit(10)
  end
  # Standard show method - empty, only for Rails RESTful routes
  def show
  end

  private

  # define an instance variable @book
  def set_book
    @book = Book.find(params[:id])
  end

  # define allowed parameters
  def book_params
    params.require(:book).permit(:title, :original_title, :sort_title, :edition, :rating, :condition, :year, :cover)
  end
end
