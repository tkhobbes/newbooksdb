# frozen_string_literal: true

class LocaleComponentPreview < ViewComponent::Preview
  def default
    render(LocaleComponent.new(locale: 'de', profile: Profile.first))
  end
end
