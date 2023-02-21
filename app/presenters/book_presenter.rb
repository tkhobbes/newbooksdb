# frozen_string_literal: false

# Decorator / presenter methods for books
# methods can be called with @book.decorate.method_name
# rubocop:disable Rails/OutputSafety
class BookPresenter < SimpleDelegator
  include ActionView::Helpers
  include ActionView::Context # for content_tag to work
  include Rails.application.routes.url_helpers # for the link_to functions

  # this method decorates the original title of a book into brackets
  def show_original_title(wrapper: '', wrapper_styles: '')
    wrap_in("(#{original_title})", wrapper, wrapper_styles).html_safe if original_title.present?
  end

  # this method shows links to all authors of a book
  def all_authors_link(styles: '', wrapper: 'span', wrapper_styles: '')
    return if authors.blank?
    safe_join(
      authors.map do |author|
        content_tag wrapper, class: wrapper_styles do
          link_to(author.display_name, author, class: styles)
        end
      end,
      ', '
    )
    # author_link = ''
    # authors.each do |author|
    #   author_link << wrap_in(link_to(author.display_name, author, class: styles),
    #       wrapper, wrapper_styles).html_safe << ', '
    # end
    # author_link.html_safe
  end

  # this method decorates the link to an author with an optional wrapper and styles
  # This method smells of :reek:DuplicateMethodCall
  def author_link(styles: '', wrapper: nil, wrapper_styles: '')
    return if authors.blank?
    wrap_in(
      link_to(
        authors.first.display_name, authors.first, class: styles
      ) << (authors.count > 1 ? ' et al.' : ''),
      wrapper, wrapper_styles
    ).html_safe
  end

  # this is a simplified decorator for author - just shows "(by authorname)"
  def author_by
    "(by #{authors.first.display_name}#{authors.count > 1 ? ' et al.' : ''})" if authors.present?
  end

  # this method decorates the link to a publisher with an optional wrapper and styles
  def publisher_link(styles: '', wrapper: nil, wrapper_styles: '')
    wrap_in(link_to(publisher.name, publisher, class: styles),
        wrapper, wrapper_styles).html_safe if publisher
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
