# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BookFormats' do
  describe 'authentication' do
    context 'must log in' do
      let(:format) { create(:book_format) }
      let(:fallback_format) { create(:fallback_format) }

      it 'cannot see any book formats if not logged in' do
        get book_formats_path(locale: 'en')
        expect(response).not_to have_http_status(:success)
      end

      it 'cannot change a book format if not logged in' do
        patch book_format_path(format.id, locale: 'en'), params: {
          book_format: {
            name: 'new name'
          }
        }
        expect(format.reload.name).to eq('default')
      end

      it 'cannot delete a book format if not logged in' do
        delete book_format_path(format.id, locale: 'en')
        expect(BookFormat.where(id: format.id).count).to be(1)
      end

      it 'cannot create a book format if not logged in' do
        post book_formats_path, params: {
          book_format: {
            name: 'new format'
          }
        }
        expect(BookFormat.where(name: 'new format')).to be_empty
      end

      it 'cannot change the default if not logged in' do
        post update_default_book_formats_path, params: {
          book_format: {
            name: 'default'
          }
        }
        expect(fallback_format.reload.fallback).to be(true)
      end

    end

    context 'has logged in' do
      let(:profile) { create(:profile) }
      let!(:format) { create(:book_format) }
      let!(:fallback_format) { create(:fallback_format) }

      it 'can see the book formats index if logged in' do
        sign_in profile.owner
        get book_formats_path
        expect(response).to have_http_status(:success)
      end

      it 'can create a book format if logged in' do
        sign_in profile.owner
        post book_formats_path, params: {
          book_format: {
            name: 'new format'
          }
        }
        expect(BookFormat.where(name: 'new format').count).to be(1)
      end

      it 'can change a book format if logged in' do
        sign_in profile.owner
        patch book_format_path(format.id, locale: 'en'), params: {
          book_format: {
            name: 'new name'
          }
        }
        expect(format.reload.name).to eq('new name')
      end

      it 'can delete a book format if logged in' do
        sign_in profile.owner
        delete book_format_path(format.id, locale: 'en')
        expect(BookFormat.where(id: format.id)).to be_empty
      end

      it 'can change the default if logged in' do
        sign_in profile.owner
        post update_default_book_formats_path, params: {
          book_format: {
            name: 'default'
          }
        }
        expect(fallback_format.reload.fallback).to be(false)
        expect(format.reload.fallback).to be(true)
      end
    end
  end
end
