# frozen_string_literal: true

module TestHelpers
  module UserAuth
    def log_me_in(user)
    visit login_path
    fill_in 'E-Mail', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    sleep 1
    end
  end
end
