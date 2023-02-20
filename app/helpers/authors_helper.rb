# frozen_string_literal: true

module AuthorsHelper
  # store the number of authors in a cache
  def authors_count
    Rails.cache.fetch('authors-count') { Author.count }
  end
end
