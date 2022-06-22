# Standard Rails helper module
module BooksHelper

  # returns the original title of a book in brackets if it is available
  def original_title(book)
    if book.original_title.present?
      "(" + book.original_title + ")"
    end
  end
end
