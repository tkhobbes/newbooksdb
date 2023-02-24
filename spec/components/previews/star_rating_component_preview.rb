# frozen_string_literal: true

# Preview for Star Ratings
class StarRatingComponentPreview < ViewComponent::Preview

  # Star Rating
  # ---
  # Shows the rating of anything "rateable" (concern) with stars;
  # filled star for each point of rating, up to 5.
  # If humanized is true, it will also show the rating text (good, bad, etc)
  # @param humanized toggle
  def default(humanized: true)
    render(StarRatingComponent.new(rated: Book.last, humanized:))
  end
end
