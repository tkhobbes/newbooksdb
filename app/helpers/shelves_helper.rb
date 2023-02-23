# frozen_string_literal: true

# iterates through all shelves and a few extra items to create a dictionary for the shelf tabs
module ShelvesHelper

  # create a dictionnary for all shelves with index
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # this method smells of :reek:DuplicateMethodCall
  # this method smells of :reek:TooManyStatements
  def shelf_menu(owner)
    menu = [
      {name: 'All Books', path: books_path},
      {name: 'Books in no Shelf', path: books_path(no_shelf: true)},
    ]
    if owner
      menu << {name: 'My Books', path: books_path(my_books: owner.id)}
      owner.shelves.each do |shelf|
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

end
