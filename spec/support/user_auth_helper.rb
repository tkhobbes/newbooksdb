# frozen_string_literal: true

# helper module to assemble a few methods that we need across tests
module TestHelpers
  # module for authentication
  module UserAuth
    # log in a given user through capybara
    def log_me_in(user)
    visit login_path
    fill_in 'E-Mail', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    sleep 1
    end
  end
end
