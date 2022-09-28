# frozen-string_literal: true

# standard rails controller for shelves; these actions are all only used within the
# settings menu
class ShelvesController < ApplicationController
  # we need the session helper and the user concerns to ensure only logged in users can tamper with formats
  include SessionsHelper
  include UserConcerns

  before_action :logged_in_user
  before_action :correct_or_admin_user, only: [:edit, :update, :destroy]

  before_action :dissolve

  # lists all shelves - only user owned if user is not admin
  def index
    if current_user.admin?
      @shelves = Shelf.all.order(:name).includes([:user])
    else
      @shelves = current_user.shelves.all.order(:name).includes([:user])
    end
  end

  def edit

  end

  def update

  end

  def new

  end

  def create

  end

  def destroy

  end

  private
  # confirms the correct user, or user is an admin
  def correct_or_admin_user
    return if current_user.admin?
    @user = @shelf.user
    redirect_to(root_path, status: :see_other) unless current_user?(@user)
  end

  # rails strong params
  def shelf_params
    params.require(:shelf).permit(:name)
  end
end
