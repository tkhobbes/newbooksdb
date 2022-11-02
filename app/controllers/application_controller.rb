# frozen_string_literal: true

# Standard Rails Application Controller
# Includes the Pagy Backend helper
# registers the path where somebody is coming from
# registers flash types info, error and success
class ApplicationController < ActionController::Base

  # include the Pagy Backend helper
  include Pagy::Backend

  # by default, we capture the path
  before_action :capture_path

  # register more flash types
  add_flash_types :info, :error, :success


  # enable turbo frame variants
  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end
end
