# frozen_string_literal: true

# Standard module for Genre helper classes
module GenresHelper

  # helper method to retrieve cache for number of genres
  def genres_count
    Rails.cache.fetch('genres-count') { Genre.count }
  end

end
