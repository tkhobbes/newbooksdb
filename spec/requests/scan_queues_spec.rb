# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CoverSearch' do
  describe 'authentication' do
    context 'must log in' do
      it 'cannot see a list of scan queues if not logged in' do
        get scan_queues_path(locale: 'en')
        expect(response).not_to have_http_status(:success)
      end

      it 'cannot create a new scan queue if not logged in' do
        get new_scan_queue_path(locale: 'en')
        expect(response).not_to have_http_status(:success)
      end

      it 'cannot create a scan queue if not logged in' do
        post scan_queues_path(isbn: '9783161484100', locale: 'en')
        expect(response).not_to have_http_status(:success)
      end

      it 'cannot delete a scan queue if not logged in' do
        delete scan_queue_path(id: '9783161484100', locale: 'en')
        expect(response).not_to have_http_status(:success)
      end

    end

    context 'has logged in' do
      let(:profile) { create(:profile) }
      let!(:queues) { Kredis.set profile.owner.id.to_s }

      it 'can see a list of scan queues if logged in' do
        sign_in profile.owner
        get scan_queues_path(locale: 'en')
        expect(response).to have_http_status(:success)
      end

      it 'can create a new scan queue if logged in' do
        sign_in profile.owner
        get new_scan_queue_path(locale: 'en')
        expect(response).to have_http_status(:success)
      end

      it 'can create a scan queue if logged in' do
        sign_in profile.owner
        post scan_queues_path(isbn: '9783161484100', locale: 'en')
        expect(queues).to include('9783161484100')
      end

      it 'can delete a scan queue if logged in' do
        sign_in profile.owner
        queues << '9783161484100'
        delete scan_queue_path(id: '9783161484100', locale: 'en')
        expect(queues).not_to include('9783161484100')
      end
    end
  end
end
