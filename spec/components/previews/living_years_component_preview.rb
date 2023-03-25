# frozen_string_literal: true

# preview for LivingYearsComponent
class LivingYearsComponentPreview < ViewComponent::Preview
  # LivingYears
  # ----
  # Outputs either one of the following, depending on whether an author has
  # a birth year, a death year, or none of the two.
  # - Born: YYYY
  # - Died: YYYY
  # - YYYY - YYYY
  # - nothing
  def default_view
    render(LivingYearsComponent.new(author: Author.first))
  end
end
