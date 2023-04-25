# frozen_string_literal: true

# component to display either a link for a locale or just the current locale
class LocaleComponent < ViewComponent::Base
  def initialize(locale:, profile:)
    super
    @locale = locale
    @profile = profile
  end

  def print_link?
    return true if @profile.nil?
    @locale != @profile[:userlocale]
  end
end
