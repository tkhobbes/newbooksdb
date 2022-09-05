# frozen_string_literal: true

# standard Rails controller for the books model
class UsersController < ApplicationController
  # users need to be logged in as the right user for certain actions
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :index

  # set user instance variable
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # delete backlinks stack on book show page
  before_action :dissolve, only: [:destroy]

  def index
    @users = User.all
  end

  # Standard Rails method to showe a new user form
  def new
    @user = User.new
  end

  # Standard Rails method to create a new user
  def create
    @user = User.new(user_params)

    if @user.save
      reset_session # rails built in
      log_in @user # directly log in the user after creation
      redirect_to @user, success: 'You successfully signed up'
    else
      render :new, status: :unprocessable_entity
    end

  end

  # standard Rails method to show a user - only used for view
  def show;
    console
  end

  # standard Rails method to show user edit form
  def edit; end

  # standard Rails method to update a user
  def update
    if @user.update(user_params)
      redirect_to @user, success: 'Your profile has been updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Standard Rails method to destroy a user
  def destroy
    redirect_to root_path unless current_user.admin? || current_user?(@user)
    @user.destroy
    redirect_to root_path, alert: 'User removed.', status: :see_other
  end

  private

  # confirms a logged-in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:warning] = "Please log in"
      redirect_to login_path, status: :see_other
    end
  end

  # confirms the correct user
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path, status: :see_other) unless current_user?(@user)
  end

  # confirms a admin user
  def admin_user
    redirect_to root_path, status: :see_other unless current_user.admin?
  end

  # allowing params for user
  # admin is NOT part of the strong params - users are not allowed to update themselves to admins
  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :avatar
    )
  end

  # find a user
  def set_user
    @user = User.find(params[:id])
  end

end
