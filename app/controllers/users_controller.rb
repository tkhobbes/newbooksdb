# frozen_string_literal: true

# standard Rails controller for the books model
class UsersController < ApplicationController
  # need the methods from user concerns
  include UserConcerns

  # users need to be logged in as the right user for certain actions
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :index

  # set user instance variable
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # delete backlinks stack on book show page
  before_action :dissolve, only: [:destroy]

  # lists all users; only accessible for admins
  def index
    @users = User.includes([avatar_attachment: :blob]).order(:name)
  end

  # Standard Rails method to showe a new user form
  def new
    @user = User.new
  end

  # Standard Rails method to create a new user
  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email
      redirect_to root_path, success: 'Please check your e-mail to activate your account'
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
      redirect_to @user, success: 'Your profile has been updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Standard Rails method to destroy a user
  # This method smells of :reek:TooManyStatements
  def destroy
    @user.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to book_formats_path, status: :see_other }
    end
  end

  private

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
