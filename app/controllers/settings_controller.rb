# frozen_string_literal: true

# Standard rails controller for the settings page
class SettingsController < ApplicationController
  # we need the session helper and the user concerns to ensure only logged in users can tamper with formats
  include SessionsHelper
  include UserConcerns

  before_action :logged_in_user
  before_action :admin_user, only: [:bulk_actions]

  # standard method to display the index page
  def index; end

  # bulk actions shows a bunch of things like "delete all genres without books"
  def bulk_actions; end

  private
  # confirms the correct user, or user is an admin
  def admin_user
    return if current_user.admin?
    redirect_to(root_path, status: :see_other)
  end
end
