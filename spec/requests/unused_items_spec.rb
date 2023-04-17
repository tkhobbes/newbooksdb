# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Unused Items' do
  describe 'authentication' do
    context 'must log in' do
      it 'cannot access the index of all unused items if not logged in' do
        get unused_items_path, params: {
          items_in: 'Tag',
          show: 'no_taggings'
        }
        expect(response).not_to have_http_status(:success)
      end

      it 'cannot delete any items if not logged in' do
        create(:tag)
        delete unused_item_path(1), params: {
          items_in: 'Tag',
          show: 'no_taggings'
        }
        expect(Tag.count).to eq(1)
      end
    end

    context 'has logged in' do
      let(:profile) { create(:profile) }

      it 'cannot access the index of all unused items if not admin' do
        get unused_items_path, params: {
          items_in: 'Tag',
          show: 'no_taggings'
        }
        expect(response).not_to have_http_status(:success)
      end

      it 'cannot delete any items if not logged in' do
        sign_in profile.owner
        create(:tag, owner: profile.owner)
        delete unused_item_path(1), params: {
          items_in: 'Tag',
          show: 'no_taggings'
        }
        expect(Tag.count).to eq(1)
      end
    end
  end

  describe 'authorization' do
    let(:profile) { create(:admin_profile) }

    context 'is admin' do
      it 'can see the index if an admin' do
        sign_in profile.owner
        get unused_items_path, params: {
          items_in: 'Tag',
          show: 'no_taggings'
        }
        expect(response).to have_http_status(:success)
      end

      it 'can delete items if an admin' do
        sign_in profile.owner
        create(:tag)
        delete unused_item_path(1), params: {
          items_in: 'Tag',
          show: 'no_taggings'
        }
        expect(Tag.count).to eq(0)
      end

      it 'cannot delete unauthorized items even if admin' do
        format = create(:book_format)
        Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner: profile.owner
        )
        delete unused_item_path(1), params: {
          items_in: 'Book',
          show: 'no_shelf'
        }
        expect(Book.count).to eq(1)
      end
    end
  end
end
