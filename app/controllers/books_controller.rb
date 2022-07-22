# standard Rails controller for the books model
class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # standard index method - show all books
  def index
    @pagy, @books = pagy(Book.includes([cover_attachment: :blob]).order(:sort_title))
  end

  # as we are using a view component, we need to render the component (and now show.htmlerb view required)
  def show
    render(BookDetailComponent.new(book: @book))
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
