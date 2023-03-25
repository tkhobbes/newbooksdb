# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Owner, type: :model do
  describe 'scopes display the right owners' do
    before do
      @owner1 = FactoryBot.create(:owner)
      @owner2 = FactoryBot.create(:owner, email: 'jane@doe.com')
    end
    context 'owner exclusions' do
      it 'excludes owners from being returned by scope' do
        owners = Owner.all_but(@owner1)
        expect(owners).to include(@owner2)
        expect(owners).not_to include(@owner1)
      end
    end # owner exclusions context
  end # scopes

  describe 'owner name and e-mail' do
    before do
      @owner = FactoryBot.create(:owner, email: 'JOHN@EXAMPLE.COM')
    end
    context 'owner name' do
      it 'takes the left hand side of the @ of the e-mail address as ownername' do
        expect(@owner.ownername).to eq('john')
      end
    end # owner name context

    context 'e-mail address' do
      it 'lowercases the e-mail address' do
        expect(@owner.email).to eq('john@example.com')
      end
    end # e-mail address context
  end # owner name and e-mail

  describe 'delegated from profile' do
    before do
      @profile = FactoryBot.create(:profile)
      @owner = @profile.owner
      @profile_admin = FactoryBot.create(:admin_profile)
      @owner_admin = @profile_admin.owner
    end
    context 'responding to delegated methods' do
      it 'can answer to name' do
        expect(@owner.name).to eq('JonnyD')
      end

      it 'can answer to admin' do
        expect(@owner_admin.admin).to eq(true)
        expect(@owner.admin).to eq(false)
      end
    end # responding to delegated methods context
  end # delegated from profile
end
# rubocop:enable Metrics/BlockLength