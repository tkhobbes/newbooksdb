# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Publishers' do
  describe 'authentication' do
    context 'not logged in' do
      it 'can see publishers index without login' do
        get publishers_path(locale: 'en')
        expect(response).to have_http_status(:success)
      end

      it 'can see genres show without login' do
        publisher = create(:publisher)
        get publisher_path(publisher.id, locale: 'en')
        expect(response).to have_http_status(:success)
      end
    end

    context 'must log in' do
      it 'cannot create a publisher without being logged in' do
        post publishers_path, params: {
          publisher: {
            name: 'APub'
          }
        }
        expect(Publisher.count).to eq(0)
      end

      it 'cannot update a publisher without being logged in' do
        publisher = create(:publisher)
        patch publisher_path(publisher.id, locale: 'en'), params: {
          publisher: {
            name: 'bla'
          }
        }
        expect(publisher.reload.name).to eq('Books Inc.')
      end

      it 'cannot delete a publisher without being logged in' do
        publisher = create(:publisher)
        delete publisher_path(publisher.id, locale: 'en')
        expect(Publisher.count).to eq(1)
      end
    end

    context 'has logged in' do
      let(:profile) { create(:profile) }

      it 'can create a publisher when logged in' do
        sign_in profile.owner
        post publishers_path, params: {
          publisher: {
            name: 'APub'
          }
        }
        expect(Publisher.count).to eq(1)
      end

      it 'can update a publisher when logged in' do
        publisher = create(:publisher)
        sign_in profile.owner
        patch publisher_path(publisher.id, locale: 'en'), params: {
          publisher: {
            name: 'Bla'
          }
        }
        expect(publisher.reload.name).to eq('Bla')
      end

      it 'can delete a publisher when logged in' do
        publisher = create(:publisher)
        sign_in profile.owner
        delete publisher_path(publisher.id, locale: 'en')
        expect(Publisher.count).to eq(0)
      end
    end
  end

end
