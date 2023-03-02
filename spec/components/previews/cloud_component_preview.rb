# frozen_string_literal: true

# preview for CloudComponent
class CloudComponentPreview < ViewComponent::Preview
  # Cloud
  # ----
  # A component that creates a cloud for a model, based on books_count.
  # The model must have a field "name" and a field "books_count" as
  # the output is a number of spans that are block elements,
  # you might want to wrap into a flexbox.

  def default
    render(CloudComponent.new(model: 'Genre'))
  end
end
