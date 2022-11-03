# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'edit and update a book', type: :system do

  before(:all) do
    @book = create(:hobbit) # belongs to :me
  end

  scenario 'User can edit their own book' do
    visit edit_book_path(@book)
    expect(page).to have_content('Edit Book')
  end

  scenario "User cannot edit another user's book" do
    visit book_path(@book)
    find('.edit-icon').click
    expect(page).to have_content('You cannot change or delete')
  end

end
