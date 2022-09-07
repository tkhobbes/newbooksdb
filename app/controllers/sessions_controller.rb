# frozen_string_literal: true

# Rails controller that handles sessions - no model behind
# Taken from Michael Hartl's Rails Tutorial
class SessionsController < ApplicationController

  # delete backlinks stack on book show page
  before_action :dissolve

  # show a login form
  def new; end

  # if user has logged in - check and if ok, redirect to show page
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # This method smells of :reek:TooManyStatements
  # This method smells of :reek:DuplicateMethodCall
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url] # if a user has to login first
        reset_session # rails built in
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || user
      else # user not activated
        redirect_to root_path, error: 'Account not activated. Check your e-mail for the activation link.'
      end
    else # user not found or password wrong
      flash.now[:error] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  # destroys a session and logs out user
  def destroy
    log_out if logged_in?
    redirect_to root_path, status: :see_other
  end

end
