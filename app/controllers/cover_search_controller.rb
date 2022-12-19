 # frozen_string_literal: true

 # controller to find better Covers
 class CoverSearchController < ApplicationController

  # create - a new search
  def create
    cover_url = Openlibrary::CoverSearch.new(isbn: params[:isbn]).cover_url
    if cover_url.present?
      #attach the picture and redirect to the book
      redirect_to book_path(params[:book_id]), success: 'New cover stored'
    else
      # no cover url found, redirect to the book
      redirect_to book_path(params[:book_id]), error: 'Could not retrieve a cover'
    end
  end
 end
