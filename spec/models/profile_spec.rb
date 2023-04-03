# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile do
  let(:profile) { create(:profile) }

  describe 'validations' do
    subject { profile }

    context 'when a profile is created' do
      it 'must have an owner' do
        profile = Profile.new(owner: nil, name: 'JD')
        expect(profile).not_to be_valid
      end

      it 'defaults to admin = false' do
        expect(profile.admin).to be false
      end
    end
  end

end
