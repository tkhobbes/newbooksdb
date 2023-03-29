# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag do
  describe 'validations' do
    let(:tag1) { create(:tag) }
    let(:tag2) { create(:tag, name: 'blue', owner: create(:jimbeam)) }

    context 'uniqueness' do
      it 'can have the same name if the owners are different' do
        tag3 = Tag.create(
          name: 'red',
          owner: tag2.owner
        )
        expect(tag3).to be_valid
      end

      it 'cannot have the same name if the owners are the same' do
        tag4 = Tag.create(
          name: 'red',
          owner: tag1.owner
        )
        expect(tag4).not_to be_valid
      end
    end # context uniqueness
  end # describe validations

  describe 'slugs' do
    let(:tag) { create(:tag) }

    context 'create slugs from name and owner' do
      it 'uses ownername to be part of a slug' do
        expect(tag.slug).to eq('red-jonnyd')
      end
    end # context create slugs from name and owner

  end # describe slugs

  describe 'scopes' do
    let(:tag1) { create(:tag) }
    let(:tag2) { create(:tag2) }
    let(:format) { create(:book_format) }

    context 'not used' do
      it 'shows not used tags properly' do
        Book.create(
          title: 'A book',
          owner: tag1.owner,
          book_format: format,
          tags: [ tag1 ]
        )
        expect(Tag.no_taggings).to include(tag2)
        expect(Tag.no_taggings).not_to include(tag1)
      end

    end # context not used
  end # describe scopes

end
