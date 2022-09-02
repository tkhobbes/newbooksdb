# frozen_string_literal: true

# This module contains various helpers for state / session management
module SessionsHelper

  # Login the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # log out the current user
  def log_out
    reset_session
    @current_user = nil
  end

  # returns the current logged in user (if any)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # returns true if a user is logged in, otherwise false
  def logged_in?
    !current_user.nil?
  end
end
