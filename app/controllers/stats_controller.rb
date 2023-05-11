# frozen_string_literal: true

# controller handles all statistics
class StatsController < ApplicationController
  def index
    @books = Book.all
    @authors = Author.all
    @genres = Genre.all
    @publishers = Publisher.all
  end
end
