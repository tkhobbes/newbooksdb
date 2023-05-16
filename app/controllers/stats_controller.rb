# frozen_string_literal: true

# controller handles all statistics
class StatsController < ApplicationController
  def index
    if params[:list] == 'authors'
      @authors = Author.all
    else
      @books = Book
        .includes([:owner, :authors, cover_attachment: :blob])
        .order(:sort_title)
      @genres = Genre.all
      @publishers = Publisher.all
      @book_formats = BookFormat.all
      @shelves = current_owner.shelves.all if current_owner
    end
  end
end
