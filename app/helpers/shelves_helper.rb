# frozen_string_literal: true

# iterates through all shelves and a few extra items to create a dictionary for the shelf tabs
module ShelvesHelper

  def shelf_menu(user)
    menu = [
      {name: 'All Books', path: books_path},
      {name: 'Books in no Shelf', path: books_path(no_shelf: true)},
    ]
    if user
      menu << {name: 'My Books', path: books_path(my_books: user.id)}
      user.shelves.each do |s|
        menu << {name: s.name, path: books_path(shelf_books: s.id)}
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

end
