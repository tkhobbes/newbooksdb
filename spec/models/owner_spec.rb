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
    let!(:owner) { create(:owner, email: 'JOHN@EXAMPLE.COM') }

    context 'owner name' do
      it 'takes the left hand side of the @ of the e-mail address as ownername' do
        expect(owner.ownername).to eq('john')
      end
    end # owner name context

    context 'e-mail address' do
      it 'must have an e-mail address' do
        invalid_owner = Owner.new(email: nil, password: 'password')
        expect(invalid_owner).not_to be_valid
      end

      it 'must have a unique e-mail address' do
        invalid_owner = Owner.new(email: 'john@example.com', password: 'password')
        expect(invalid_owner).not_to be_valid
      end

      it 'must have a password' do
        invalid_owner = Owner.new(email: 'tolkien@rivendell.com', password: nil)
        expect(invalid_owner).not_to be_valid
      end

      it 'lowercases the e-mail address' do
        expect(owner.email).to eq('john@example.com')
      end
    end # e-mail address context
  end # owner name and e-mail

  describe 'defaults' do
    let(:owner) { create(:owner) }

    context 'book-counts' do
      let(:format) { create(:book_format) }

      it 'has a default of 0 for books count' do
        expect(owner.books_count).to eq 0
      end

      it 'increases books count by 1 if book for owner is added' do
        Book.create(
          title: 'The Hobbit',
          owner:,
          book_format: format
        )
        expect(owner.reload.books_count).to eq 1
      end
    end
  end

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
