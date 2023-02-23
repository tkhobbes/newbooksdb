# frozen_string_literal: true

# Standard Rails Application Helper
# includes the Pagy Frontent helper
module ApplicationHelper
  include Pagy::Frontend

  # figures out what path we need to show for the owner menu in the title
  def login_or_owner_path
    owner_signed_in? ? profile_path(current_owner.profile.id) : new_owner_session_path
  end

  # standard method to set page title and browser window title
  # this method smells of :reek:TooManyStatements
  def page_title(title, browser_title = '', title_class = '')
    browser_title = title if browser_title.blank?
    title_class = 'heading2' if title_class.blank?

    content_for :browser_title do
      "#{browser_title}  | "
    end
    content_for :title do
      content_tag(:h1, class: title_class) do
        title
      end
    end if title.present?
  end

  # returns span tags with filled stars equal to the rating and empty stars to fill up to 5
  def rating_stars(rating)
    content_tag(:span, class: 'color-accent') do
      (inline_svg_tag('star-filled.svg', class: 'smallicon') * rating) <<
      (inline_svg_tag('star.svg', class: 'smallicon') * (5- rating))
    end
  end

  # method to list out all menu items for main menu
  # rubocop:disable Metrics/MethodLength
  # this method smells of :reek:DuplicateMethodCall
  def menu_items
    [
      {
        name: 'Home',
        path: root_path
      },
      {
        name: 'Books',
        path: books_path,
      },
      {
        name: 'Genres',
        path: genres_path,
      },
      {
        name: 'Authors',
        path: authors_path,
      },
      {
        name: 'Publishers',
        path: publishers_path
      },
      {
        name: 'Tags',
        path: tags_path(list: 'books')
      }
    ].map do |item|
      {
        name: item[:name],
        path: item[:path],
        active: current_page?(item[:path]) || "/#{params[:controller]}" == item[:path]
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  def pluck_list(model, sort_column)
    model.pluck(sort_column)&.map { |sort| sort[0] }&.tally
  end

  # Caching methods
  # books cache
  def books_count
    Rails.cache.fetch('books-count') { Book.count }
  end

  # authors cache
  def authors_count
    Rails.cache.fetch('authors-count') { Author.count }
  end

  # shelves cache
  def shelves_count
    Rails.cache.fetch('genres-count') { Shelf.count }
  end

  # publishers cache
  def publishers_count
    Rails.cache.fetch('publishers-count') { Publisher.count }
  end

  # owners cache
  def owners_count
    Rails.cache.fetch('owners-count') { Owner.count }
  end

  # genres cache
  def genres_count
    Rails.cache.fetch('genres-count') { Genre.count }
  end
end
