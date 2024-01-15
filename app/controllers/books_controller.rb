# frozen_string_literal: true

# standard Rails controller for the books model
# rubocop:disable Metrics/ClassLength
# this method smells of :reek:TooManyMethods
class BooksController < ApplicationController
  # everybody can see index and an individual book, but only logged in owners can add / update / delete
  before_action :authenticate_owner!, only: %i[new create edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]

  # standard rails - set instance variable for standard actions
  before_action :set_book, only: %i[show edit update destroy]

  # delete backlinks stack on book show page
  before_action :dissolve, only: [:show]

  #  allow for turbo frame variants
  before_action :turbo_frame_request_variant

  # scopes as filters - repeating from model
  has_scope :my_books
  has_scope :shelf_books
  has_scope :no_shelf, type: :boolean, allow_blank: true
  has_scope :letter

  # ensure we can sort the view of books
  include Sortable

  # standard index method - show all books
  # books ordered by sort_title; additional variable @pagy for pagination
  def index
    @pagy, @books = per_page(apply_scopes(
                               order(:sort_title,
                                     include_owner(
                                       view_includes(
                                         default_includes(Book.all)
                                       )
                                     ))
                             ))
  end

  # Standard show method - show book details
  def show; end

  # standard new method - show form for new book
  def new
    @book = Book.new
    @book.authors.build
  end

  # standard edit method - show form for editing book
  def edit; end

  # creation / storage of a new book
  def create
    new_params = update_book_format_param(book_params)
    @book = Book.new(new_params.merge(owner_id: current_owner.id))

    if @book.save
      flash[:success] = t('books.save')
      redirect_to book_path(@book)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # update of a book
  def update
    if @book.update(book_params)
      flash[:success] = t('books.update')
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
      format.html { redirect_to books_url, alert: t('books.destroy'), status: :see_other }
    end
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def stats
    return if params[:criteria].blank? || params[:filter].blank? || VALID_CRITERIA.exclude?(params[:criteria])

    @criteria = params[:criteria] # what is the criteria to filter on? Ratings, years, ...?
    @filter = params[:filter] # what is the filter value to apply?
    # we need to distinguish between simple value criteria and ENUM criterias
    if @criteria == 'rating' || @criteria == 'condition' # ENUM Criteria
      book_enum_stats(@criteria, @filter)
    elsif @criteria == 'country' # simple criteria
      book_stats(@criteria, @filter)
    elsif @criteria == 'genre' # criteria based on another table
      book_join_stats(@criteria, @filter)
    elsif @criteria == 'publisher' || @criteria == 'shelf' || @criteria == 'book_format' # criteria based on another table
      book_join_single_stats(@criteria, @filter)
    elsif @criteria == 'year' # criteria based on "in-between" values
      book_year_stats(@criteria, @filter)
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('itemlist', partial: 'books/stats', locals: { books: @books })
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  VALID_CRITERIA = %w[rating condition country year genre publisher shelf book_format].freeze

  def book_enum_stats(criteria, filter)
    @books = Book
             .includes([cover_attachment: :blob])
             .order(:sort_title)
             # the criteria has to be in backticks as "condition" is a reserved word in MySql
             .send(:where, "`#{criteria}`=#{Book.send(criteria.pluralize.to_s)[filter.to_s]}")
  end

  def book_stats(criteria, filter)
    @books = Book
             .includes([cover_attachment: :blob])
             .order(:sort_title)
             # the criteria has to be in backticks as "condition" is a reserved word in MySql
             .send(:where, "`#{criteria}`='#{filter}'")
  end

  def book_year_stats(criteria, filter)
    decades = [
      { legend: '1900-20s', start_year: 1900, end_year: 1929 },
      { legend: '1930-40s', start_year: 1930, end_year: 1949 },
      { legend: '1950-60s', start_year: 1950, end_year: 1969 },
      { legend: '1970s', start_year: 1970, end_year: 1979 },
      { legend: '1980s', start_year: 1980, end_year: 1989 },
      { legend: '1990s', start_year: 1990, end_year: 1999 },
      { legend: '2000s', start_year: 2000, end_year: 2009 },
      { legend: '2010s', start_year: 2010, end_year: 2019 },
      { legend: '2020s', start_year: 2020, end_year: 2029 }
    ]
    start_year = decades.detect { |d| d[:legend] == filter }[:start_year]
    end_year = decades.detect { |d| d[:legend] == filter }[:end_year]
    @books = Book
             .includes([cover_attachment: :blob])
             .order(:sort_title)
             # the criteria has to be in backticks as "condition" is a reserved word in MySql
             .send(:where, "`#{criteria}`>=#{start_year} AND `#{criteria}`<=#{end_year}")
  end

  def book_join_stats(criteria, filter)
    @books = Book
             .includes([cover_attachment: :blob])
             .order(:sort_title)
             .joins(criteria.pluralize.to_sym)
             # the criteria has to be in backticks as "condition" is a reserved word in MySql
             .send(:where, "`#{criteria.pluralize.to_sym}`.name='#{filter}'")
  end

  def book_join_single_stats(criteria, filter)
    @books = Book
             .includes([cover_attachment: :blob])
             .order(:sort_title)
             .joins(criteria.to_sym)
             # the criteria has to be in backticks as "condition" is a reserved word in MySql
             .send(:where, "`#{criteria.pluralize.to_sym}`.name='#{filter}'")
  end

  # ensure the correct user can edit / update / delete a book
  def correct_user
    return if current_owner == Book.friendly.find(params[:id]).owner

    redirect_to root_path,
                status: :see_other,
                error: t('books.correct_user')
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

  # a set of methods that help to scope the @books variable for the index action
  #  inclusion of default associations
  # this method smells of :reek:UtilityFunction
  def default_includes(collection)
    collection.includes([:authors, cover_attachment: :blob])
  end

  # includes the owner if somebody is logged in
  def include_owner(collection)
    if current_owner
      collection.includes(:owner)
    else
      collection
    end
  end

  # includes the right associated models based on the view selected
  def view_includes(collection)
    if params[:show] == 'list'
      collection
    else
      collection.includes(%i[publisher rich_text_synopsis books_genres genres])
    end
  end

  # returns the right amount of items for pagination
  def per_page(collection)
    if params[:show] == 'list'
      pagy(collection, items: 20)
    else
      pagy(collection)
    end
  end

  # returns all books sorted by sort_title, with associations included to avoid n+1
  # this method smells of :reek:UtilityFunction
  def books_with_includes_sorted
    Book
      .includes([:owner, :authors, cover_attachment: :blob])
      .order(:sort_title)
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
      :country,
      :cover,
      :synopsis,
      :book_format_id,
      :shelf_id,
      :publisher_id,
      :isbn,
      :tag_list, # is this needed?
      genre_ids: [],
      tag_ids: [],
      author_ids: [],
      authors_attributes: %i[
        id
        first_name
        last_name
        born
        died
        gender
      ]
    )
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ClassLength
