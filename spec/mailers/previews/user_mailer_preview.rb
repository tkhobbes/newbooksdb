# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/account_activation
  # this method smells of :reek:UtilityFunction
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  # this method smells of :reek:UtilityFunction
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
end
