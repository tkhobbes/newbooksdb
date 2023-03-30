# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile do
  describe 'validations' do
    let(:profile) { create(:profile) }

    context 'owner' do
      it 'must have an owner' do
        profile = Profile.new(owner: nil, name: 'JD')
        expect(profile).not_to be_valid
      end
    end

    context 'admin' do
      it 'defaults to admin = false' do
        expect(profile.admin).to be false
      end
    end
  end

end
