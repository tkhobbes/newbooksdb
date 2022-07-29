# frozen_string_literal: true

# A module / concern for all models that are rateable.
# Provides ENUMs for ratings as follows:
# 0 - not_rated, 1 - hated, 2 - bad, 3 - ok, 4 - good, 5 - favourite
# Also provides a method rated? that returns true if a rating is set.
module Rateable
  extend ActiveSupport::Concern

  included do
    enum rating: {
      favourite: 5,
      good: 4,
      ok: 3,
      bad: 2,
      hated: 1,
      not_rated: 0,
    }

    # returns true if there is a rating set
    # @return [Boolean]
    def rated?
      rating != 'not_rated'
    end
  end
end
