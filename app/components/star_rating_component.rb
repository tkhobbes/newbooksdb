# frozen_string_literal: true

# displays a star rating that is equal to the rating of the rated object
# can also show the rating in a human readable form
class StarRatingComponent < ViewComponent::Base

  def initialize(rated:, humanized:)
    super
    @rated = rated
    @rating = @rated.rating
    @rating_value = @rated.read_attribute_before_type_cast('rating')
    @humanized = humanized
  end

  # returns span tags with filled stars equal to the rating and empty stars to fill up to 5
  def star_rating
    content_tag(:span, class: 'color-accent') do
      (inline_svg_tag('star-filled.svg', class: 'smallicon') * @rating_value) <<
      (inline_svg_tag('star.svg', class: 'smallicon') * (5 - @rating_value))
    end
  end

  def humanized_rating
    "(#{@rating.humanize})"
  end

end
