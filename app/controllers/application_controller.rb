# frozen_string_literal: true

# Standard Rails Application Controller
# Includes the Pagy Backend helper
# registers the path where somebody is coming from
# registers flash types info, error and success
class ApplicationController < ActionController::Base
  around_action :switch_locale

  # Devise i18n
  before_action do
    I18n.locale = owner_locale || I18n.default_locale
  end

  # locale handling
  # this method smells of :reek:UtilityFunction
  def default_url_options
    { locale: I18n.locale }
  end

  def switch_locale(&)
    locale = owner_locale || I18n.default_locale
    I18n.with_locale(locale, &)
  end

  # include the Pagy Backend helper
  include Pagy::Backend

  # by default, we capture the path
  before_action :capture_path

  # register more flash types
  add_flash_types :info, :error, :success

  # Prosopite enablement
  # unless Rails.env.production?
  #   around_action :n_plus_one_detection

  #   def n_plus_one_detection
  #     Prosopite.scan
  #     yield
  #   ensure
  #     Prosopite.finish
  #   end
  # end

  # enable turbo frame variants
  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

  private

  # retrieve locale
  # this method smells of :reek:NilCheck
  # This method smells of :reek:DuplicateMethodCall
  def owner_locale
    return if current_owner.nil? || current_owner.profile.nil?
    current_owner.profile[:userlocale]
  end
end
