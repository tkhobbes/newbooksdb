# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'fiddling with book formats', type: :system do
  before(:all) do
    @default_format = create(:not_defined)
    @hardcover_format = create(:hardcover)
    @softcover_format = create(:softcover)
    @user = create(:me) # :me is an admin
  end

  scenario 'The fallback format shows " (default)" after its name' do
    visit book_formats_path
    expect(page).to have_content('Not defined (default)')
  end

  scenario 'if the fallback format is changed, so is the "default" prefix' do
    visit book_formats_path
    Capybara.match = :first
    find('#change-default').click
    select('Hardcover', from: 'book_format[name]')
    find('input[type=submit]').click
    expect(page).to have_content('Hardcover (default)')
  end
end
