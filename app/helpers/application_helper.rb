# frozen_string_literal: true

# Standard Rails Application Helper
# includes the Pagy Frontent helper
module ApplicationHelper
  include Pagy::Frontend

  # figures out what path we need to show for the user menu in the title
  def login_or_user_path
    logged_in? ? user_path(current_user) : login_path
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
end
