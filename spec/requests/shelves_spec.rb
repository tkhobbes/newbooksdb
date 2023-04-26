# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Shelves' do
  let(:profile) { create(:profile) }
  let(:admin_profile) { create(:admin_profile) }

  describe 'authentication' do
    context 'must log in' do
      it 'cannot see any shelves if not logged in' do
        get shelves_path(locale: 'en')
        expect(response).not_to have_http_status(:success)
      end
    end

    context 'has logged in' do
      let(:shelf) { create(:shelf, owner: profile.owner) }

      it 'can see their own shelves if logged in' do
        sign_in profile.owner
        get shelves_path(locale: 'en')
        expect(response).to have_http_status(:success)
      end

      it 'can create a shelf if logged in' do
        sign_in profile.owner
        post shelves_path, params: {
          shelf: {
            name: 'test', owner: profile.owner
          }
        }
        expect(Shelf.count).to eq(1)
      end

      it 'can update a shelf if logged in' do
        sign_in profile.owner
        patch shelf_path(shelf, locale: 'en'), params: {
          shelf: {
            name: 'New Name'
          }
        }
        expect(shelf.reload.name).to eq('New Name')
      end

      it 'can remove a shelf if logged in' do
        sign_in profile.owner
        delete shelf_path(shelf, locale: 'en')
        expect(Shelf.count).to eq(0)
      end
    end
  end

  describe 'authorization' do
    let(:shelf) { create(:shelf, owner: profile.owner) }
    let(:shelf2) { create(:shelf, name: 'Shelf 2', owner: admin_profile.owner) }

    context 'own shelves only' do
      it 'cannot update other owners shelves' do
        sign_in profile.owner
        patch shelf_path(shelf2, locale: 'en'), params: {
          shelf: {
            name: 'New Name'
          }
        }
        expect(shelf2.reload.name).to eq('Shelf 2')
      end

      it 'cannot remove other owners shelves' do
        sign_in profile.owner
        delete shelf_path(shelf2, locale: 'en')
        expect(Shelf.find(shelf2.id)).to be_present
      end
    end

    context 'is admin' do
      it 'can update any shelf' do
        sign_in admin_profile.owner
        patch shelf_path(shelf, locale: 'en'), params: {
          shelf: {
            name: 'New Name'
          }
        }
        expect(shelf.reload.name).to eq('New Name')
      end

      it 'can remove any shelf' do
        sign_in admin_profile.owner
        delete shelf_path(shelf, locale: 'en')
        expect(Shelf.where(id: shelf.id)).to be_empty
      end
    end
  end
end
