 # frozen_string_literal: true

 # controller to find better Covers
 class CoverSearchController < ApplicationController
  before_action :authenticate_owner!, only: [:create]

  # create - a new search
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # this method smells of :reek:TooManyStatements
  # this method smells of :reek:DuplicateMethodCall
  # this method smells of :reek:NilCheck
  def create
    Book.find(params[:book_id]).update(cover_searched: true)
    cover_url = Openlibrary::CoverSearch.new(value: params[:isbn]).cover_url
    book_id = params[:book_id]
    if cover_url.present?
      #attach the picture and redirect to the book
      book = Book.find(book_id)
      result = PictureAttacher.new(cover_url, book.cover).attach
      if result.created?
        redirect_to book_path(book_id), success: t('covers.success')
      else
        redirect_to book_path(book_id), error: result.message
      end
    else
      # no cover url found, redirect to the book
      redirect_to book_path(book_id), error: t('covers.error')
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
 end
