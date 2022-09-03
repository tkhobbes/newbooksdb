# frozen_string_literal: true

# Rails controller that handles sessions - no model behind
# Taken from Michael Hartl's Rails Tutorial
class SessionsController < ApplicationController

  # delete backlinks stack on book show page
  before_action :dissolve

  # show a login form
  def new; end

  # if user has logged in - check and if ok, redirect to show page
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url] # if a user has to login first
      reset_session # rails built in
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user
      redirect_to forwarding_url || user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path, status: :see_other
  end

end
