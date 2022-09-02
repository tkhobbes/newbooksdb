# frozen_string_literal: true

# This module contains various helpers for state / session management
module SessionsHelper

  # Login the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # remembers a user in a persistent session
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
    @current_user = nil
  end

  # returns the current logged in user (if any)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # returns true if a user is logged in, otherwise false
  def logged_in?
    !current_user.nil?
  end
end
