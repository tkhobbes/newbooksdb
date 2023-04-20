# frozen_string_literal: true

# Standard Rails controller for Authors
# can respond to turbo frames and includes concern Sortable
class AuthorsController < ApplicationController
  # allow for turbo frame variants
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
        default_includes(Author.all)
      )
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
      redirect_to author_path(@author), success: "#{Author.model_name.human} saved"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      flash[:success] = "#{Author.model_name.human} updated"
      redirect_to @author
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to authors_url, alert: "#{Author.model_name.human} removed", status: :see_other }
    end
  end

  private

  # a set of methods that help to scope the @books variable for the index action

  # inclusion of default associations
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
