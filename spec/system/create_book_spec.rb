# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'creating a book', type: :system do

  before(:all) do
    @default_format = create(:not_defined)
    @hardcover_format = create(:hardcover)
    @softcover_format = create(:softcover)
    @user = create(:me) # :me is an admin
  end

  scenario 'only logged in users can create books' do
    visit new_book_path
    expect(page).to have_content('Login')
  end

  scenario 'Valid input and format given' do
    log_me_in(@user)
    visit new_book_path
    fill_in 'Book Title', with: 'The Hobbit'
    fill_in 'Book Format', with: 'Hardcover'
    click_on 'Create Book'
    visit books_path
    expect(page).to have_content('The Hobbit')
  end

  scenario 'Valid input and no format given' do
    log_me_in(@user)
    visit new_book_path
    fill_in 'Book Title', with: 'The Hobbit'
    click_on 'Create Book'
    expect(page).to have_content('Not defined')
  end

  scenario 'Invalid input given' do
    log_me_in(@user)
    visit new_book_path
    click_on 'Create Book'
    expect(page).to have_content("Title can't be blank")
  end

  scenario 'Original title displayed in brackets' do
    log_me_in(@user)
    visit new_book_path
    fill_in 'Book Title', with: 'Der kleine Hobbit'
    fill_in 'Original Title', with: 'The Hobbit'
    click_on 'Create Book'
    expect(page).to have_content('(The Hobbit)')
  end

  # this test needs to be refactored - it does not test that we have 4 filled stars
  # - it just tests that there are sv.smallicons which we have anyway.
  # we should do something like
  # scan('fill="currentColor"').size).to eq(@book.rating_before_type_cast)
  scenario 'rating is expressed with stars' do
    log_me_in(@user)
    visit new_book_path
    fill_in 'Book Title', with: 'The Hobbit'
    find('#label_rating_good').click
    click_on 'Create Book'
    expect(page).to have_css('svg.smallicon')

  end

  scenario 'show a synopsis if there is one' do
    log_me_in(@user)
    visit new_book_path
    fill_in 'Book Title', with: 'Lord of the Rings'
    find('#book_synopsis').click.set('A great book')
    click_on 'Create Book'
    expect(page).to have_content('Synopsis')
  end

  scenario 'Do not show a synopsis if there is none' do
    log_me_in(@user)
    visit new_book_path
    fill_in 'Book Title', with: 'Lord of the Rings'
    click_on 'Create Book'
    expect(page).not_to have_content('Synopsis')
  end

  scenario 'display fallback svg if there is no image' do
    log_me_in(@user)
    visit new_book_path
    fill_in 'Book Title', with: 'The Hobbit'
    click_on 'Create Book'
    expect(page).to have_css('svg.placeholder-large')
  end

  scenario 'displays a cover image if there is one', js: true do
    log_me_in(@user)
    visit new_book_path
    fill_in 'Book Title', with: 'Catcher in the Rye'
    # Capybara.match = :first
    # find('input[type="file"]', visible: false).set('db/sample/images/cover-1.jpg')
    attach_file('db/sample/images/cover-1.jpg') do
      find('.dropzone').click
    end
    click_on 'Create Book'
    expect(page).to have_css('div.cover-large img')
  end
end
# rubocop:enable Metrics/BlockLength
