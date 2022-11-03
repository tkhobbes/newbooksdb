# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Basic Owner tests', type: :system do

  before(:all) do
    @book1 = create(:random_book)
    @book2 = create(:random_book)
    @book3 = create(:hobbit)
    @owner = @book3.owner # :me
    @owner_to_delete = @book1.owner
  end

  # scenario 'A Owner can login' do
  #   visit login_path
  #   fill_in 'E-Mail', with: @user.email
  #   fill_in 'Password', with: @user.password
  #   click_on 'Log in'
  #   expect(page).to have_content('Profile')
  # end

  scenario 'books can be transferred after deleting a user' do
    books_of_owner_to_delete = @owner_to_delete.books.size
    books_of_new_owner = @owner.books.size
    click_on 'Delete my Profile'
    select @owner.name, from: 'transfer_to_owner'
    click_on 'Confirm'
    sleep 1
    expect(@owner.books.size).to eq(books_of_new_owner + books_of_owner_to_delete)
  end

end
