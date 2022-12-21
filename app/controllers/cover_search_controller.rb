 # frozen_string_literal: true

 # controller to find better Covers
 class CoverSearchController < ApplicationController

  # create - a new search
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # this method smells of :reek:TooManyStatements
  # this method smells of :reek:DuplicateMethodCall
  # this method smells of :reek:NilCheck
  def create
    cover_url = Openlibrary::CoverSearch.new(value: params[:isbn]).cover_url
    book_id = params[:book_id]
    if cover_url.present?
      #attach the picture and redirect to the book
      book = Book.find(book_id)
      result = PictureAttacher.new(cover_url, book.cover).attach
      if result.nil?
        redirect_to book_path(book_id), error: 'Could not retrieve a cover'
      else
        redirect_to book_path(book_id), success: 'New cover stored'
      end
    else
      # no cover url found, redirect to the book
      redirect_to book_path(book_id), error: 'Could not retrieve a cover'
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
 end
