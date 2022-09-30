#frozen_string_literal: true

# standard module with helper methods for publisher
module PublishersHelper
  # count all publishers
  def publishers_count
    Rails.cache.fetch('publishers-count') { Publisher.count }
  end
end
