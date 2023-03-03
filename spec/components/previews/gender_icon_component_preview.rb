# frozen_string_literal: true

class GenderIconComponentPreview < ViewComponent::Preview
  # Gender Icon
  # ----
  # renders a "male" or a "female" icon (mars / venus)
  #@!group type
  def male
    render(GenderIconComponent.new(author: Author.where(gender: 'male').first))
  end

  def female
    render(GenderIconComponent.new(author: Author.where(gender: 'female').first))
  end
  #@!endgroup
end
