# frozen_string_literal: true

# non-standard controller for various more static pages
class HomeController < ApplicationController

  def index
    @books = Book.all.includes([cover_attachment: :blob]).order(created_at: :desc).limit(5)
  end
end
