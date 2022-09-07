# frozen_string_literal: true

# Rails controller that handles account activations - no model behind
# Taken from Michael Hartl's Rails Tutorial
class AccountActivationsController < ApplicationController

  # edit method activates users
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      redirect_to user, success: 'Account activated!'
    else
      redirect_to root_url, error: 'Invalid activation link'
    end
  end
end
