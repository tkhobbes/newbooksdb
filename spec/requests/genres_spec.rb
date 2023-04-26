# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Genres' do
  describe 'authentication' do
    context 'not logged in' do
      it 'can see genres index without login' do
        get genres_path(locale: 'en')
        expect(response).to have_http_status(:success)
      end

      it 'can see genres show without login' do
        genre = create(:genre)
        get genre_path(genre.id, locale: 'en')
        expect(response).to have_http_status(:success)
      end
    end

    context 'must log in' do
      it 'cannot create a genre without being logged in' do
        post genres_path, params: {
          genre: {
            name: 'something'
          }
        }
        expect(Genre.count).to eq(0)
      end

      it 'cannot update a genre without being logged in' do
        genre = create(:genre)
        patch genre_path(genre.id, locale: 'en'), params: {
          genre: {
            name: 'bla'
          }
        }
        expect(genre.reload.name).to eq('Action')
      end

      it 'cannot delete a genre without being logged in' do
        genre = create(:genre)
        delete genre_path(genre.id, locale: 'en')
        expect(Genre.count).to eq(1)
      end

      it 'cannot see the admin view without being logged in' do
        get genres_path(locale: 'en'), params: { show: 'settings' }
        expect(response).not_to have_http_status(:success)
      end
    end

    context 'has logged in' do
      let(:profile) { create(:profile) }

      it 'can see the admin view when logged in' do
        sign_in profile.owner
        get genres_path(locale: 'en'), params: { show: 'settings' }
        expect(response).to have_http_status(:success)
      end

      it 'can create a genre when logged in' do
        sign_in profile.owner
        post genres_path, params: {
          genre: {
            name: 'Fantasy'
          }
        }
        expect(Genre.count).to eq(1)
      end

      it 'can update a genre when logged in' do
        genre = create(:genre)
        sign_in profile.owner
        patch genre_path(genre.id, locale: 'en'), params: {
          genre: {
            name: 'SciFi'
          }
        }
        expect(genre.reload.name).to eq('SciFi')
      end

      it 'can delete a genre when logged in' do
        genre = create(:genre)
        sign_in profile.owner
        delete genre_path(genre.id, locale: 'en')
        expect(Genre.count).to eq(0)
      end
    end
  end
end
