# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shelf do
  describe 'validations' do
    let(:shelf) { create(:shelf) }

    context 'presence and defaults' do
      it 'must have a name' do
        invalid_shelf = Shelf.new(name: nil, owner: shelf.owner)
        expect(invalid_shelf).not_to be_valid
      end

      it 'must have an owner' do
        invalid_shelf = Shelf.new(name: 'Invalid', owner: nil)
        expect(invalid_shelf).not_to be_valid
      end

      it 'defaults books_count to 0' do
        expect(shelf.books_count).to eq 0
      end

      it 'increases books_count when a book is added' do
        Book.create(
          title: 'The Book',
          owner: shelf.owner,
          book_format: create(:book_format),
          shelf:
        )
        expect(shelf.reload.books_count).to eq 1
      end


    end

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
