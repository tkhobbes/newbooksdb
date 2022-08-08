# frozen_string_literal: true

class BookFormatsController < ApplicationController
  before_action :set_book_format, only: [:show, :edit, :update, :destroy]
  before_action :set_default_book_format, only: [:index, :set_default, :update_default]

  # delete backlinks stack on book show page
  before_action :dissolve, only: [:index]

  #index action - displayed in a turbo frame within the settings page
  def index
    @book_formats = BookFormat.all.order(:name)
  end

  #new action - displayed in a turbo frame within the settings page
  def new
    @book_format = BookFormat.new
  end

  #standard rails create action
  def create
    @book_format = BookFormat.new(book_format_params)

    respond_to do |format|
      if @book_format.save
        format.turbo_stream
        format.html { redirect_to book_format_path(@book_format) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end

    end
  end

  #edit action - displayed in a turbo frame within the settings page
  def edit; end

  #standard rails update action
  def update
    if @book_format.update(book_format_params)
      redirect_to book_formats_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  #standard rails destroy action
  def destroy
    return if @book_format.id == 1 # prevent deletion of "Not specified"
    @book_format.destroy
    respond_to do |format|
      # format.turbo_stream { render turbo_stream: turbo_stream.remove(@book_format) }
      format.turbo_stream
      format.html { redirect_to book_formats_path, status: :see_other }
    end
  end

  # custom method to define the default book format (form display)
  def set_default
    @book_formats = BookFormat.all.order(:name)
    respond_to do |format|
      format.turbo_stream
    end
  end

  # custom method to actually update the default book format
  def update_default
    @new_default = BookFormat.find_by(name: book_format_params[:name])
    @default_book_format.update(fallback: false)
    @new_default.update(fallback: true)
    @default_book_format = @new_default
    @book_formats = BookFormat.all.order(:name)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to book_formats_path }
    end
  end

  private

  # retrieve a book format from the database
  def set_book_format
    @book_format = BookFormat.find(params[:id])
  end

  def set_default_book_format
    @default_book_format = BookFormat.find_by(fallback: true)
  end

  def book_format_params
    params.require(:book_format).permit(:name, :fallback)
  end

end
