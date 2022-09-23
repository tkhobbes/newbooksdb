# frozen_string_literal: true

# Standard Rails controller for the tag model
class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # we need the session helper and the user concerns to ensure only logged in users can tamper with formats
  include SessionsHelper
  include UserConcerns

  before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: :full_index

  before_action :dissolve, only: [:show]

  # index method only lists tags from the currently logged in user
  def index
    @user = current_user
    @tags = @user.tags
  end

  # this lists ALL tags from all users
  def full_index

  end

  def show

  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

    # confirms the correct user
  def correct_user
    @user = @tag.user
    redirect_to(root_path, status: :see_other) unless current_user?(@user)
  end

  # confirms a admin user
  def admin_user
    redirect_to root_path, status: :see_other unless current_user.admin?
  end

  # standard rails method to find a tag
  def set_tag
    @tag = Tag.friendly.find(params[:id])
  end

  # strong parameters
  def tag_params
    params.require(:tag).permit(:name, :user_id)
  end
end
