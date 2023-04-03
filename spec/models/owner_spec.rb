# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Owner do
  describe 'validations' do
    subject { owner }

    let!(:owner) { create(:owner, email: 'JOHN@EXAMPLE.COM') }


    context 'when a owner is created / registers' do
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

      it 'has a default of 0 for books count' do
        expect(owner.books_count).to eq 0
      end
    end

    context 'when a book is created for the owner' do
      let(:format) { create(:book_format) }

      it 'increases books count for the owner' do
        Book.create(
          title: 'The Hobbit',
          owner:,
          book_format: format
        )
        expect(owner.reload.books_count).to eq 1
      end
    end
  end

  describe 'scopes' do
    let(:owner1) { create(:owner) }
    let(:owner2) { create(:owner, email: 'jane@doe.com') }

    context 'when there are multiple owners' do
      it 'correctly excludes owners from "all_but"' do
        owners = Owner.all_but(owner1)
        expect(owners).to include(owner2)
        expect(owners).not_to include(owner1)
      end
    end # owner exclusions context
  end # scopes

  describe 'delegated from profile' do
    subject { owner }

    let!(:profile) { create(:profile) }
    let!(:owner) { profile.owner }
    let!(:profile_admin) { create(:admin_profile) }
    let!(:owner_admin) { profile_admin.owner }


    context 'when a profile is associated with an owner' do
      it 'takes the left hand side of the @ of the e-mail address as ownername' do
        expect(owner.ownername).to eq('john')
      end

# owner name context
      it 'can answer to name' do
        expect(owner.name).to eq('JonnyD')
      end

      it 'can answer to admin' do
        expect(owner_admin.admin).to be(true)
        expect(owner.admin).to be(false)
      end
    end
  end
end
