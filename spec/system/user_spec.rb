# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Basic User tests', type: :system do

  before(:all) do
    @user = create(:me)
  end

  scenario 'A User can login' do
    visit login_path
    fill_in 'E-Mail', with: @user.email
    fill_in 'Password', with: @user.password
    click_on 'Log in'
    expect(page).to have_content('Profile')
  end

end
