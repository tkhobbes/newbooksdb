# frozen_string_literal: true

class BookFormatsController < ApplicationController
  before_action :set_book_format, only: [:show, :edit, :update, :destroy]

  #index action - displayed in a turbo frame within the settings page
  def index
    @formats = BookFormat.all.order(:format)
  end

  #new action - displayed in a turbo frame within the settings page
  def new
    @format = BookFormat.new
  end

  #standard rails create action
  def create; end

  #edit action - displayed in a turbo frame within the settings page
  def edit; end

  #standard rails update action
  def update; end

  #standard rails destroy action
  def destroy; end

  private

  # retrieve a book format from the database
  def set_book_format
    @format = BookFormat.find(params[:id])
  end

end
