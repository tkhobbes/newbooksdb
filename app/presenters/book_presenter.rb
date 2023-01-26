# frozen_string_literal: true

# Decorator / presenter methods for books
# methods can be called with @book.decorate.method_name
# rubocop:disable Rails/OutputSafety
class BookPresenter < SimpleDelegator
  include ActionView::Helpers
  include Rails.application.routes.url_helpers # for the link_to functions

  # this method decorates the original title of a book into brackets
  def show_original_title(wrapper: '', wrapper_styles: '')
    wrap_in("(#{original_title})", wrapper, wrapper_styles).html_safe if original_title.present?
  end

  # this method decorates the link to an author with an optional wrapper and styles
  def author_link(styles: '', wrapper: nil, wrapper_styles: '')
    wrap_in(link_to(authors.first.display_name, authors.first, class: styles),
        wrapper, wrapper_styles).html_safe if authors.present?
  end

  # this is a simplified decorator for author - just shows "(by authorname)"
  def author_by
    "(by #{authors.first.display_name})" if authors.present?
  end

  # this method decorates the link to a publisher with an optional wrapper and styles
  def publisher_link(styles: '', wrapper: nil, wrapper_styles: '')
    wrap_in(link_to(publisher.name, publisher, class: styles),
        wrapper, wrapper_styles).html_safe if publisher
  end

  # this method decorates the output of the book synopsis
  # this method smells of :reek:BooleanParameter
  # this method smells of :reek:ControlParameter
  # this method smells of :reek:DuplicateMethodCall
  def show_synopsis(wrapper: nil, wrapper_styles: '', title: false)
    return if synopsis.blank?
    if title
      "<h3 class='#{wrapper_styles}-title'>Synopsis</h3>".html_safe <<
      wrap_in(raw(synopsis), wrapper, wrapper_styles).html_safe
    else
      wrap_in(raw(synopsis), wrapper, wrapper_styles).html_safe
    end
  end

  # decorator for synopsis - shows truncated to x characters
  def show_trunc_synopsis(characters: 100)
    truncate(strip_tags(synopsis.to_s), length: characters)
  end

  private

  # helper method to wrap content into a wrapper tag such as div or span
  # this method smells of :reek:UtilityFunction
  def wrap_in(content, wrapper, styles)
    if wrapper
      "<#{wrapper} class='#{styles}'>" <<
        content <<
      "</#{wrapper}>"
    else
      content
    end
  end
end

# rubocop:enable Rails/OutputSafety
