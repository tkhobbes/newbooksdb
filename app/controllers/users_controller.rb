# frozen_string_literal: true

# standard Rails controller for the books model
class UsersController < ApplicationController
  # users need to be logged in as the right user for certain actions
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

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
      flash[:success] = 'You successfully signed up'
      redirect_to user_path(@user)
    else
      render :new, status: :unprocessable_entity
    end

  end

  # standard Rails method to show a user - only used for view
  def show
    @user = User.find(params[:id])
  end

  # standard Rails method to show user edit form
  def edit
    @user = User.find(params[:id])
  end

  # standard Rails method to update a user
  def update
    @user= User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Your profile has been updated'
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Standard Rails method to destroy a user
  def destroy
    @user.destroy
    redirect_to root_path, alert: 'User destroyed.', status: :see_other
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

  # allowing params for user
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # find a user
  def set_user
    @user = User.find(params[:id])
  end

end
