# frozen_string_literal: true

# iterates through all shelves and a few extra items to create a dictionary for the shelf tabs
module ShelvesHelper

  # create a dictionnary for all shelves with index
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # this method smells of :reek:DuplicateMethodCall
  # this method smells of :reek:TooManyStatements
  def shelf_menu(user)
    menu = [
      {name: 'All Books', path: books_path},
      {name: 'Books in no Shelf', path: books_path(no_shelf: true)},
    ]
    if user
      menu << {name: 'My Books', path: books_path(my_books: user.id)}
      user.shelves.each do |shelf|
        menu << {name: shelf.name, path: books_path(shelf_books: shelf.id)}
      end
    end
    menu.map.with_index do |item, index|
      {
        name: item[:name],
        path: item[:path],
        i: index,
        active: current_page?(item[:path], check_parameters: true)
      }
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  # shows the shelf for a book if available
  # This method smells of :reek:DuplicateMethodCall
  # rubocop:disable Layout/LineLength
  def show_shelf(book)
    return unless logged_in? && book.user == current_user && book.shelf
    "in shelf #{link_to(book.shelf.name, books_path(shelf_books: book.shelf.id), class: 'color-accent-dark color-hover-accent')}"
  end
  # rubocop:enable Layout/LineLength

  # helper method to get number of shelves from cache
  def shelves_count
    Rails.cache.fetch('genres-count') { Shelf.count }
  end

end
