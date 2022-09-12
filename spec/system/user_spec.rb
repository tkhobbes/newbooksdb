# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Basic User tests', type: :system do

  before(:all) do
    @book1 = create(:random_book)
    @book2 = create(:random_book)
    @book3 = create(:hobbit)
    @user = @book3.user # :me
    @user_to_delete = @book1.user
  end

  scenario 'A User can login' do
    visit login_path
    fill_in 'E-Mail', with: @user.email
    fill_in 'Password', with: @user.password
    click_on 'Log in'
    expect(page).to have_content('Profile')
  end

  scenario 'books can be transferred after deleting a user' do
    books_of_user_to_delete = @user_to_delete.books.size
    books_of_new_user = @user.books.size
    log_me_in(@user_to_delete)
    click_on 'Delete my Profile'
    select @user.name, from: 'transfer_to_user'
    click_on 'Confirm'
    sleep 1
    expect(@user.books.size).to eq(books_of_new_user + books_of_user_to_delete)
  end

end
