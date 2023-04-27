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

  # inspiration for this method comes from
  # https://github.com/rubyapi/rubyapi/blob/f3d136b76426a24c7bb1e933f5b5e9d1a29c3fbb/app/components/header/version_selector_component.rb#L9-L16
  def menu_entry(locale)
    route = Rails.application.routes.recognize_path request.url
    route[:only_path] = true
    route[:locale] = locale
    route.merge! request.query_parameters
    url_for route
  end
end
