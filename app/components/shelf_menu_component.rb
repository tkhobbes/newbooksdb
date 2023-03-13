# frozen_string_literal: true

# Displays a list of shelf entries - based on the shelves an owner has
class ShelfMenuComponent < ViewComponent::Base

  def initialize(owner: nil)
    super
    @owner = owner
    @menu = []
    @display_menu = []
  end

  # return an array of hashes with items to display
  # this method smells of :reek:DuplicateMethodCall
  def display_menu
    build_menu
    @menu.map.with_index do |item, index|
      @display_menu << {
        name: item[:name],
        path: item[:path],
        i: index,
        active: current_page?(item[:path], check_parameters: true)
      }
    end
  end

  private

  # build full menu to display
  def build_menu
    default_entries
    build_owner_entries if @owner
  end

  # build standard entries
  def default_entries
    @menu <<
      {name: 'All Books', path: books_path} <<
      {name: 'Books in no Shelf', path: books_path(no_shelf: true)}
  end

  # build entries specific to the owner
  def build_owner_entries
    @menu << {name: 'My Books', path: books_path(my_books: @owner.id)}
    @owner.shelves.each do |shelf|
      @menu << {name: shelf.name, path: books_path(shelf_books: shelf.id)}
    end
  end

end
