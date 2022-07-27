# Standard Rails Application Controller
# Includes the Pagy Backend helper
class ApplicationController < ActionController::Base
  include Pagy::Backend

  add_flash_types :info, :error, :success
end
