#frozen_string_literal: true

# Standard Rails model for Publishers
class PublishersController < ApplicationController
  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  before_action :authenticate_owner!, only: [:new, :create, :edit, :update, :destroy]

  before_action :set_publisher, only: [:show, :edit, :update, :destroy]

  before_action :dissolve, only: [:show]

  # index method uses pagy
  def index
    @pagy, @publishers = pagy(Publisher.all
      .includes([books: [cover_attachment: :blob]])
      .order(:name))
  end

  # shows a publisher in detail and lists all books from that publisher
  def show
    @pagy, @books = pagy(@publisher.books.includes([:author, :owner, cover_attachment: :blob]))
  end

  # new method to display form
  def new
    @publisher = Publisher.new
  end

  #edit action - displayed in a turbo frame within the settings page
  def edit; end

  # creation / storage of a new publisher
  # also responds to json for on the fly creation through books form
  # this method smells of :reek:TooManyStatements
  def create
    @publisher = Publisher.new(publisher_params)

    if @publisher.save
      respond_to do |format|
        format.html { redirect_to publisher_path(@publisher), success: 'Publisher saved' }
        format.json { render json: @publisher }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  #standard rails update action
  def update
    if @publisher.update(publisher_params)
      flash[:success] = 'Publisher updated'
      redirect_to publisher_path(@publisher)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # standard destroy method
  def destroy
    @publisher.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to publishers_path, alert: 'Publisher was successfully destroyed.', status: :see_other }
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
