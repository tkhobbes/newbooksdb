# frozen_string_literal: true

# UserMailer for various account related e-mails
# from M. Hartl's Rails tutorial
class UserMailer < ApplicationMailer

  # sends a note to the user to activate account
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'Account activation'
  end

  # sends a note to a user to reset the password
  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password reset'
  end
end
