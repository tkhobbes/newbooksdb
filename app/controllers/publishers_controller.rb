#frozen_string_literal: true

# Standard Rails model for Publishers
class PublishersController < ApplicationController
  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  # we need the session helper and the user concerns to ensure only logged in users can tamper with formats
  include SessionsHelper
  include UserConcerns

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  before_action :set_publisher, only: [:show, :edit, :update, :destroy]

  before_action :dissolve, only: [:show]

  # index method uses pagy
  def index
    @pagy, @publishers = pagy(Publisher.all
      .includes([books: [cover_attachment: :blob]])
      .order(:name))
  end

  # new method to display form
  def new
    @publisher = Publisher.new
  end

  # creation / storage of a new publisher
  def create
    @publisher = Publisher.new(publisher_params)

    if @publisher.save
      flash[:success] = 'Publisher saved'
      redirect_to publisher_path(@publisher)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Rails strong params
  def publisher_params
    params.require(:publisher).permit(:name, :location)
  end

  # standard method to get the publisher using friendly ID
  def set_publisher
    @publisher = Publisher.friendly.find(params[:id])
  end
end
