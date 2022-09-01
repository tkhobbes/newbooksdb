# frozen_string_literal: true

# standard Rails controller for the books model
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # Standard Rails method to showe a new user form
  def new
    @user = User.new
  end

  # Standard Rails method to create a new user
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'You successfully signed up'
      redirect_to user_path(@user)
    else
      render :new, status: :unprocessable_entity
    end

  end

  # standard Rails method to show a user - only used for view
  def show; end

  # standard Rails method to show user edit form
  def edit; end

  # standard Rails method to update a user
  def update
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

  # allowing params for user
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # find a user
  def set_user
    @user = User.find(params[:id])
  end

end
