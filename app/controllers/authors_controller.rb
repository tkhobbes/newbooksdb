# frozen_string_literal: true

class AuthorsController < ApplicationController
  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  before_action :set_author, only: %i[show edit update destroy]

  before_action :dissolve, only: :index

  def index
    @authors = Author.all.order(:sort_name)
  end

  def show
      @pagy, @books = pagy(@author.books.includes([:user, cover_attachment: :blob]).order(:sort_title))
  end

  private

  def author_params
    params.require(:author).permit(
      :first_name,
      :last_name,
      :born,
      :died,
      :gender,
      :rating
    )
  end

  def set_author
    @author = Author.friendly.find(params[:id])
  end
end
