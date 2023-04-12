# frozen_string_literal: true

# Standard Rails controller for the book format model
class BookFormatsController < ApplicationController

  # if not logged in, cannot do anything with formats
  before_action :authenticate_owner!

  # set the book format for some actions
  before_action :set_book_format, only: [:edit, :update, :destroy]

  # ensure we know the default format for any method where it matters
  before_action :default_book_format, only: [:create, :index, :set_default, :update_default, :destroy]

  # delete backlinks stack on all bookformat actions except create
  before_action :dissolve, except: [:new, :create]

  #index action - displayed in a turbo frame within the settings page
  def index
    @book_formats = BookFormat.all.order(:name)
  end

  #new action - displayed in a turbo frame within the settings page
  def new
    @book_format = BookFormat.new
  end

  #edit action - displayed in a turbo frame within the settings page
  def edit; end

  #standard rails create action; answers to:
  # -normal html (fallback and not used)
  # -turbo stream - default response format, used on the settings page
  # -json - used as we can create formats on the fly in the book form
  # This method smells of :reek:DuplicateMethodCall
  # This method smells of :reek:TooManyStatements
  def create
    @book_format = BookFormat.new(book_format_params)

    respond_to do |format|
      if @book_format.save
        format.turbo_stream
        format.html { redirect_to book_format_path(@book_format) }
        format.json { render json: @book_format }
      else
        format.html { render :new, status: :unprocessable_entity }
      end

    end
  end

  #standard rails update action
  def update
    if @book_format.update(book_format_params)
      redirect_to book_formats_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  #standard rails destroy action - responds to
  # -html (not used)
  # -turbo-stream - default response format, used on the settings page
  # This method smells of :reek:TooManyStatements
  def destroy
    @book_format.destroy
    if @book_format.destroyed?
      respond_to do |format|
        # format.turbo_stream { render turbo_stream: turbo_stream.remove(@book_format) }
        format.turbo_stream
        format.html { redirect_to book_formats_path, status: :see_other }
      end
    else
      # in the rare occasion where the format is not deleted -
      # as it is the default - ensure that the corresponding
      # turbo stream is not removed
      render json: { nothing: true }
    end
  end

  # custom method to define the default book format (form display)
  def set_default
    @book_formats = BookFormat.all.order(:name)
  end

  # custom method to actually update the default book format
  # removes the fallback flag from the previous default book format
  def update_default
    @new_default = BookFormat.find_by(name: book_format_params[:name])
    @default_book_format.update(fallback: false)
    @new_default.update(fallback: true)
    @default_book_format = @new_default
    @book_formats = BookFormat.all.order(:name)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to book_formats_path, status: :see_other }
    end
  end

  private

  # retrieve a book format from the database
  def set_book_format
    @book_format = BookFormat.find(params[:id])
  end

  # retrieves the default format - the format with fallback = true
  def default_book_format
    @default_book_format ||= BookFormat.find_by(fallback: true)
  end

  # standard rails safe parameter method
  def book_format_params
    params.require(:book_format).permit(:name, :fallback)
  end

end
