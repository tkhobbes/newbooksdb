# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Settings' do
  describe 'authentication' do
    context 'must log in' do
      it 'cannot see the settings page if not logged in' do
        get settings_path(locale: 'en')
        expect(response).not_to have_http_status(:success)
      end

      it 'cannot run bulk actions if not logged in' do
        get bulk_actions_settings_path(locale: 'en')
        expect(response).not_to have_http_status(:success)
      end
    end

    context 'has logged in' do
      let(:profile) { create(:profile) }

      it 'can access the settings page if logged in' do
        sign_in profile.owner
        get settings_path(locale: 'en')
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'authorization' do
    let(:profile) { create(:profile) }
    let(:admin_profile) { create(:admin_profile) }

    context 'is admin' do
      it 'cannot access the bulk actions if not an admin' do
        sign_in profile.owner
        get bulk_actions_settings_path(locale: 'en')
        expect(response).not_to have_http_status(:success)
      end

      it 'can access the bulk actions if admin' do
        sign_in admin_profile.owner
        get bulk_actions_settings_path(locale: 'en')
        expect(response).to have_http_status(:success)
      end
    end
  end

end
