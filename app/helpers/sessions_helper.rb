# frozen_string_literal: true

# This module contains various helpers for state / session management
module SessionsHelper

  # Login the given user
  def log_in(user)
    session[:user_id] = user.id
    # Guard against session replay attacks
    # see https://bit.ly/33UvK0w
    session[:session_token] = user.session_token
  end

  # remembers a user in a persistent session
  # This method smells of :reek:DuplicateMethodCall
  # This method smells of :reek:FeatureEnvy
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # log out the current user
  def log_out
    forget(current_user)
    reset_session
    # rubocop:disable Rails/HelperInstanceVariable
    @current_user = nil
    # rubocop:enable Rails/HelperInstanceVariable
  end

  # returns the current logged in user (if any)
  # rubocop:disable Metrics/MethodLength
  # This method smells of :reek:DuplicateMethodCall
  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      if user && session[:session_token] == user.session_token
        # rubocop:disable Rails/HelperInstanceVariable
        @current_user = user
        # rubocop:enable Rails/HelperInstanceVariable
      end
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in user
        # rubocop:disable Rails/HelperInstanceVariable
        @current_user = user
        # rubocop:enable Rails/HelperInstanceVariable
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # returns true if a user is logged in, otherwise false
  # This method smells of :reek:NilCheck
  def logged_in?
    !current_user.nil?
  end

  # returns true if the given user is the current user
  def current_user?(user)
    user && user == current_user
  end

  # store URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url
  end
end
