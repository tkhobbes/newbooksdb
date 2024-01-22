# frozen_string_literal: true

# Standard Rails controller for Authors
# can respond to turbo frames and includes concern Sortable
class AuthorsController < ApplicationController
  #  allow for turbo frame variants
  before_action :turbo_frame_request_variant

  # only signed in owners can create, edit and delete authors
  before_action :authenticate_owner!, except: %i[index show]

  before_action :set_author, only: %i[edit update destroy]

  before_action :dissolve, only: :index

  has_scope :no_books
  has_scope :dead
  has_scope :alive
  has_scope :letter

  # ensure we can sort authors
  include Sortable

  def index
    @pagy, @authors = per_page(apply_scopes(
                                 order(:sort_name,
                                       default_includes(Author.all))
                               ))
  end

  def show
    @author = Author.includes(tags: [:owner]).friendly.find(params[:id])
    @pagy, @books = pagy(@author
      .books
      .includes([:owner, cover_attachment: :blob])
      .order(:sort_title))
  end

  def new
    @author = Author.new
  end

  def edit; end

  def create
    @author = Author.new(author_params)
    if @author.save
      redirect_to author_path(@author), success: t('authors.save')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      flash[:success] = t('authors.update')
      redirect_to @author
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to authors_url, alert: t('authors.destroy'), status: :see_other }
    end
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def stats
    return if params[:criteria].blank? || params[:filter].blank? || VALID_CRITERIA.exclude?(params[:criteria])

    @criteria = params[:criteria] # what is the criteria to filter on? Ratings, years, ...?
    @filter = params[:filter] # what is the filter value to apply?
    # we need to distinguish between simple value criteria and ENUM criterias
    if @criteria == 'gender' # standard criteria
      author_stats(@criteria, @filter)
    elsif @criteria == 'alive' # specific criteria for alive / dead
      author_alive_stats(@filter)
    elsif @criteria == 'rating' # criteria based on ENUM
      author_enum_stats(@criteria, @filter)
    elsif @criteria == 'books_author' # criteria based on another table
      author_books_stats(@criteria, @filter)
    elsif @criteria == 'age' # criteria based on "in-between" values
      author_age_stats(@filter)
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('itemlist', partial: 'authors/stats', locals: { authors: @authors })
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  VALID_CRITERIA = %w[age alive gender rating books_author].freeze

  def author_stats(criteria, filter)
    @authors = Author
               .includes([portrait_attachment: :blob])
               .order(:sort_name)
               # the criteria has to be in backticks as "condition" is a reserved word in MySql
               .send(:where, "`#{criteria}`='#{filter}'")
  end

  def author_enum_stats(criteria, filter)
    @authors = Author
               .includes([portrait_attachment: :blob])
               .order(:sort_name)
               # the criteria has to be in backticks as "condition" is a reserved word in MySql
               .send(:where, "`#{criteria}`=#{Author.send(criteria.pluralize.to_s)[filter.to_s]}")
  end

  def author_books_stats(criteria, filter)
    @authors = Author
               .includes([portrait_attachment: :blob])
               .order(:sort_name)
               .joins(criteria.pluralize.to_sym)
               # the criteria has to be in backticks as "condition" is a reserved word in MySql
               .send(:where, "authors.id=#{Author.find_by(display_name: filter).id}")
  end

  def author_alive_stats(filter)
    @authors = if filter == 'alive'
                 Author
                   .includes([portrait_attachment: :blob])
                   .order(:sort_name)
                   # the criteria has to be in backticks as "condition" is a reserved word in MySql
                   .send(:where, '`died`IS NULL')
               else
                 Author
                   .includes([portrait_attachment: :blob])
                   .order(:sort_name)
                   # the criteria has to be in backticks as "condition" is a reserved word in MySql
                   .send(:where, '`died`IS NOT NULL')
               end
  end

  def author_age_stats(filter)
    ages = [
      { legend: '10 or below', start_age: 0, end_age: 10, count: 0 },
      { legend: '11-20', start_age: 11, end_age: 20, count: 0 },
      { legend: '21-30', start_age: 21, end_age: 30, count: 0 },
      { legend: '31-40', start_age: 31, end_age: 40, count: 0 },
      { legend: '41-50', start_age: 41, end_age: 50, count: 0 },
      { legend: '51-60', start_age: 51, end_age: 60, count: 0 },
      { legend: '61-70', start_age: 61, end_age: 70, count: 0 },
      { legend: '71-80', start_age: 71, end_age: 80, count: 0 },
      { legend: 'above 80', start_age: 81, end_age: 300, count: 0 }
    ]
    start_age = ages.detect { |d| d[:legend] == filter }[:start_age]
    end_age = ages.detect { |d| d[:legend] == filter }[:end_age]
    @authors = Author
               # .includes([portrait_attachment: :blob])
               .order(:sort_name)
               # the criteria has to be in backticks as "condition" is a reserved word in MySql
               .send(:where, "(`born`>=#{Time.zone.now.year - end_age} AND `born`<=#{Time.zone.now.year - start_age} AND `died`IS NULL) OR ((`died`-`born`>= #{start_age}) AND (`died`-`born`<= #{end_age}))")
  end

  # a set of methods that help to scope the @books variable for the index action

  #  inclusion of default associations
  # this method smells of :reek:UtilityFunction
  def default_includes(collection)
    collection.includes([portrait_attachment: :blob])
  end

  # returns the right amount of items for pagination
  def per_page(collection)
    pagy(collection)
  end

  # rubocop:disable Metrics/MethodLength
  def author_params
    params.require(:author).permit(
      :first_name,
      :last_name,
      :born,
      :died,
      :gender,
      :rating,
      :portrait,
      :tag_list,
      tag_ids: []
    )
  end
  # rubocop:enable Metrics/MethodLength

  def set_author
    @author = Author.friendly.find(params[:id])
  end
end
