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

  # method determines the right CSS for existing books
  # this method smells of :reek:ControlParameter
  def isbn_existing_css(existing)
    case existing
    when 'current_owner'
      'existing-current'
    when 'other_owner'
      'existing-other'
    end
  end

  # this method prints out a book title and formats depending on whether existing
  # this method smells of :reek:ControlParameter
  def isbn_existing_title(title, existing)
    case existing
    when 'current_owner'
      "#{title} (#{t('isbn.existing.owned')})"
    when 'other_owner'
      "#{title} (#{t('isbn.existing.another')})"
    else
      title
    end
  end

  # method to list out all menu items for main menu
  # this method smells of :reek:DuplicateMethodCall
  # this method smells of :reek:FeatureEnvy
  def menu_items
    menu_entries.map do |item|
      {
        name: item[:name],
        path: item[:path],
        active: current_page?(item[:path]) || "/#{params[:controller]}" == item[:path]
      }
    end
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
    Rails.cache.fetch('shelves-count') { Shelf.count }
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

  private

  # all entries for the main menu
  # rubocop:disable Metrics/MethodLength
  def menu_entries
    [
      {
        name: t('sidebar.menu.home'),
        path: root_path
      },
      {
        name: Book.model_name.human(count:10),
        path: books_path,
      },
      {
        name: Genre.model_name.human(count:10),
        path: genres_path,
      },
      {
        name: Author.model_name.human(count:10),
        path: authors_path,
      },
      {
        name: Publisher.model_name.human(count:10),
        path: publishers_path
      },
      {
        name: Tag.model_name.human(count:10),
        path: tags_path(list: 'books')
      }
    ]
  end
  # rubocop:enable Metrics/MethodLength
end
