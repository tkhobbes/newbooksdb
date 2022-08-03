# frozen_string_literal: true

class BookFormatsController < ApplicationController
  def index
    @formats = BookFormat.all.order(:format)
  end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

end
