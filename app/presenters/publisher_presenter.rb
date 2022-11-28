# frozen_string_literal: true

# Decorator / presenter methods for authors
# methods can be called with @publisher.decorate.method_name
class PublisherPresenter < SimpleDelegator
  include ActionView::Helpers
  include Rails.application.routes.url_helpers # for the link_to functions

  def more_books
    if books.empty?
      'No books for this publisher'
    else
      link_to "Show all (#{books_count} books)...", publisher_path(id)
    end
  end
end
