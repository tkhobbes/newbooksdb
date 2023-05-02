# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'IsbnSearch' do
  describe 'authentication' do
    let(:profile) { create(:profile) }

    context 'must log in' do
      it 'cannot access the new form without being logged in' do
        get isbn_search_new_path
        expect(response).not_to have_http_status(:success)
      end

      it 'can access the new form if logged in' do
        sign_in profile.owner
        get isbn_search_new_path
        expect(response).to have_http_status(:success)
      end

      it 'cannot show any results if not logged in' do
        post isbn_search_show_path, params: {
          title: 'The Hobbit'
        }
        expect(response).not_to have_http_status(:success)
      end

      it 'can display results if logged in' do
        sign_in profile.owner
        post isbn_search_show_path('en'), params: {
          title: 'The Hobbit'
        }
        expect(response).to have_http_status(:success)
      end
    end
  end

end
