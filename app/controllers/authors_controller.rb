# frozen_string_literal: true

class AuthorsController < ApplicationController
  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  before_action :set_author, only: %i[edit update destroy]

  before_action :dissolve, only: :index

  def index
    @pagy, @authors = pagy(Author.includes([portrait_attachment: :blob]).order(:sort_name))
  end

  def show
      @author = Author.includes(tags: [:user]).friendly.find(params[:id])
      @pagy, @books = pagy(@author
        .books
        .includes([:user, cover_attachment: :blob])
        .order(:sort_title))
  end

  def new
    @author = Author.new
  end

  # rubocop:disable Metrics/MethodLength
  def create
    @author = Author.new(author_params)

    if @author.save
      if params[:author][:source] == 'book'
        redirect_to new_book_path
      else
        flash[:success] = 'Author saved'
        redirect_to author_path(@author)
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  # rubocop:enable Metrics/MethodLength

  def edit; end

  def update
    if @author.update(author_params)
      flash[:success] = 'Author updated'
      redirect_to @author
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to authors_url, alert: 'Author removed', status: :see_other }
    end
  end

  private

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
