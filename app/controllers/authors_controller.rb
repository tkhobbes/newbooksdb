# frozen_string_literal: true

class AuthorsController < ApplicationController

  before_action :set_author, only: %i[show edit update destroy]

  def index
    @authors = Author.all.order(:sort_name)
  end

  def show; end

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
