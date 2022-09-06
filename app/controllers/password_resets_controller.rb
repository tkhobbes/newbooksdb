# frozen_string_literal: true

# Rails controller that handles password resets - no model behind
# Taken from Michael Hartl's Rails Tutorial
class PasswordResetsController < ApplicationController
  # we need a user, we need a valid user, and we need the token not to be expired
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  # dummy 'new' method to show the form
  def new
  end

  # create method will actually trigger the e-mail to be sent
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_path, success: 'Email sent with password reset instructions'
    else
      flash.now[:error] = 'E-Mail Address not found'
      render 'new', status: :unprocessable_entity
    end
  end

  # edit method will show the form to change the password
  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit', status: :unprocessable_entity
    elsif @user.update(user_params)
      reset_session
      log_in @user
      redirect_to @user, success: 'Password has been reset.'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  # strong parameters
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # finds a user by email
  def get_user
    @user = User.find_by(email: params[:email])
  end

  # confirms a valid user
  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_path
    end
  end

  # check expiration of reset token
  def check_expiration
    if @user.password_reset_expired?
      redirect_to new_password_reset_path, error: 'Password reset has expired.'
    end
  end
end
