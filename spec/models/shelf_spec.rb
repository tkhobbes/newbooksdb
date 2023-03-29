# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shelf do
  describe 'validations' do
    let(:shelf) { create(:shelf) }

    context 'uniqueness' do
      it 'can not have the same name for the same owner' do
        another_shelf = Shelf.new(
          name: 'Office',
          owner: shelf.owner
        )
        expect(another_shelf).not_to be_valid
      end

      it 'can have the same name if owner is different' do
        another_shelf = Shelf.new(
          name: 'Office',
          owner: create(:jimbeam)
        )
        expect(another_shelf).to be_valid
      end
    end
  end

  describe 'scopes' do
    let!(:shelf) { create(:shelf) }
    let(:shelf2) { create(:shelf, name: 'Kitchen', owner: shelf.owner) }
    let(:format) { create(:book_format) }
    let!(:owner) { shelf.owner }

    context 'book related scopes' do
      it 'shows the right shelves in the no_books scope' do
        Book.create(
          title: 'The Book',
          owner:,
          book_format: format,
          shelf:
        )
        Book.create(
          title: 'Another book',
          owner:,
          book_format: format
        )
        expect(Shelf.no_books).to include(shelf2)
        expect(Shelf.no_books).not_to include(shelf)
      end
    end
  end

end
