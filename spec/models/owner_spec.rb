# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Owner do
  describe 'scopes display the right owners' do
    let(:owner1) { create(:owner) }
    let(:owner2) { create(:owner, email: 'jane@doe.com') }

    context 'owner exclusions' do
      it 'excludes owners from being returned by scope' do
        owners = Owner.all_but(owner1)
        expect(owners).to include(owner2)
        expect(owners).not_to include(owner1)
      end
    end # owner exclusions context
  end # scopes

  describe 'owner name and e-mail' do
    let(:owner) { create(:owner, email: 'JOHN@EXAMPLE.COM') }

    context 'owner name' do
      it 'takes the left hand side of the @ of the e-mail address as ownername' do
        expect(owner.ownername).to eq('john')
      end
    end # owner name context

    context 'e-mail address' do
      it 'lowercases the e-mail address' do
        expect(owner.email).to eq('john@example.com')
      end
    end # e-mail address context
  end # owner name and e-mail

  describe 'delegated from profile' do
    let!(:profile) { create(:profile) }
    let!(:owner) { profile.owner }
    let!(:profile_admin) { create(:admin_profile) }
    let!(:owner_admin) { profile_admin.owner }

    context 'responding to delegated methods' do
      it 'can answer to name' do
        expect(owner.name).to eq('JonnyD')
      end

      it 'can answer to admin' do
        expect(owner_admin.admin).to be(true)
        expect(owner.admin).to be(false)
      end
    end # responding to delegated methods context
  end # delegated from profile
end
