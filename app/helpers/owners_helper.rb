# frozen_string_literal: true

# Owners Helper module includes various view helpers
module OwnersHelper
  # helper method to get number of owners from cache
  def owners_count
    Rails.cache.fetch('owners-count') { Owner.count }
  end

end
