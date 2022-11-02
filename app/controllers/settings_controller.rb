# frozen_string_literal: true

# Standard rails controller for the settings page
class SettingsController < ApplicationController
  before_action :authenticate_owner!
  before_action :admin_user, only: [:bulk_actions]

  # standard method to display the index page
  def index; end

  # bulk actions shows a bunch of things like "delete all genres without books"
  def bulk_actions; end

  private
  # confirms the correct owner, or owner is an admin
  def admin_user
    return if current_owner.admin?
    redirect_to(root_path, status: :see_other)
  end
end
