# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profiles' do
  describe 'authentication' do
    context 'must log in' do
      it 'cannot see any profiles without being logged in' do
        get profiles_path(locale: 'en')
        expect(response).not_to have_http_status(:success)
      end
    end

    context 'has logged in' do
      let(:profile) { create(:profile) }

      it 'can see their own profile' do
        sign_in profile.owner
        get profile_path(profile, locale: 'en')
        expect(response).to have_http_status(:success)
      end

      it 'can see another profile' do
        other_profile = create(:admin_profile)
        sign_in profile.owner
        get profile_path(other_profile, locale: 'en')
        expect(response).to have_http_status(:success)
      end

      it 'can see all profiles' do
        sign_in profile.owner
        get profiles_path(locale: 'en')
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'authorization' do
    let(:profile) { create(:profile) }
    let(:admin_profile) { create(:admin_profile) }

    context 'has logged in but wrong user' do
      it 'cannot change another profile' do
        sign_in profile.owner
        patch profile_path(admin_profile, locale: 'en'), params: {
          profile: {
            name: 'New Name'
          }
        }
        expect(admin_profile.reload.name).to eq('Admin James')
      end
    end

    context 'has logged in and is the correct user' do
      it 'can edit the profile' do
        sign_in profile.owner
        patch profile_path(profile, locale: 'en'), params: {
          profile: {
            name: 'New Name'
          }
        }
        expect(profile.reload.name).to eq('New Name')
      end
    end

    context 'is admin' do
      it 'can edit any profile' do
        sign_in admin_profile.owner
        patch profile_path(profile, locale: 'en'), params: {
          profile: {
            name: 'New Name'
          }
        }
        expect(profile.reload.name).to eq('New Name')
      end
    end
  end
end
