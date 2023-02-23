# frozen_string_literal: true

# Book Helper module includes various view helpers
module BooksHelper

  # sets the title to display on the index page for books, depending on what we see
  # this method smells of :reek:DuplicateMethodCall
  def book_index_title
    letter_title = params[:letter] ? " starting with #{params[:letter].upcase}" : ''
    if params[:my_books]
      "My Books#{letter_title}"
    elsif params[:shelf_books]
      "Books in Shelf '#{Shelf.find(params[:shelf_books]).name}'#{letter_title}"
    else
      "All Books#{letter_title}"
    end
  end

  # method extends existing scope of books_path with new scope
  def scoped_books_path(show_hash)
    new_scopes = current_scopes.merge(show_hash)
    books_path(new_scopes)
  end

end
