# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag do
  describe 'validations' do
    subject { tag1 }

    let(:tag1) { create(:tag) }
    let(:tag2) { create(:tag, name: 'blue', owner: create(:jimbeam)) }


    context 'when a tag is created' do
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

      it 'must have a name' do
        invalid_tag = Tag.new(name: nil, owner: tag1.owner)
        expect(invalid_tag).not_to be_valid
      end

      it 'uses ownername to be part of a slug' do
        expect(tag1.slug).to eq('red-jonnyd')
      end
    end
  end # describe validations

  describe 'scopes' do
    subject { tag1 }

    let(:tag1) { create(:tag) }
    let(:tag2) { create(:tag2) }
    let(:format) { create(:book_format) }


    context 'when tags are not used' do
      it 'not used tags properly show up under the no_taggings scope' do
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
