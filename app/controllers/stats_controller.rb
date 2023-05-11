# frozen_string_literal: true

# controller handles all statistics
class StatsController < ApplicationController
  def index
    if params[:list] == 'authors'
      @authors = Author.all
    else
      @books = Book.all
      @genres = Genre.all
      @publishers = Publisher.all
      @book_formats = BookFormat.all
      if current_owner
        @shelves = current_owner.shelves.all
      end
    end
  end
end
