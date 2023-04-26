# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Destructions' do
  describe 'authentication' do
    context 'must log in' do
      let(:profile) { create(:profile) }

      it 'cannot access the new form if not logged in' do
        get new_user_destructions_path(profile, locale: 'en')
        expect(response).not_to be_successful
      end

      it 'cannot create a user destruction if not logged in' do
        post user_destructions_path, params: {
          current_owner_id: profile.owner.id
        }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'authorization' do
    context 'normal user' do
      let(:profile) { create(:profile) }

      it 'can access the new form if logged in' do
        sign_in profile.owner
        get new_user_destructions_path(profile, locale: 'en')
        expect(response).to be_successful
      end

      it 'can delete the own profile' do
        new_owner = create(:jimbeam)
        format = create(:book_format)
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner: profile.owner
        )
        Book.create(
          title: 'The Lord of the Rings',
          book_format: format,
          owner: new_owner
        )
        sign_in profile.owner
        binding.pry
        post user_destructions_path, params: {
          current_owner_id: profile.owner.id,
          book_selection: 'transfer',
          transfer_to_owner: new_owner.email
        }
        expect(new_owner.reload.books).to include(book)
      end

    end

    context 'admin' do
      let(:admin_profile) { create(:admin_profile) }

      it 'can create any user destruction if an admin' do
        old_profile = create(:profile)
        new_owner = create(:owner, email: 'jane@example.com')
        format = create(:book_format)
        Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner: old_profile.owner
        )
        Book.create(
          title: 'The Lord of the Rings',
          book_format: format,
          owner: new_owner
        )
        sign_in admin_profile.owner
        post user_destructions_path, params: {
          current_owner_id: old_profile.owner.id,
          book_selection: 'transfer',
          transfer_to_owner: new_owner.email
        }
        expect(new_owner.reload.books.count).to eq(2)
      end
    end
  end
end
