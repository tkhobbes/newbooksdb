# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Shelf, type: :model do
  describe 'validations' do
    before do
      @shelf = FactoryBot.create(:shelf)
    end

    context 'uniqueness' do
      it 'can not have the same name for the same owner' do
        shelf = Shelf.new(
          name: 'Office',
          owner: @shelf.owner
        )
        expect(shelf).to_not be_valid
      end

      it 'can have the same name if owner is different' do
        shelf = Shelf.new(
          name: 'Office',
          owner: FactoryBot.create(:jimbeam)
        )
        expect(shelf).to be_valid
      end
    end
  end

  describe 'scopes' do
    before do
      @shelf = FactoryBot.create(:shelf)
      @shelf2 = FactoryBot.create(:shelf, name: 'Kitchen', owner: @shelf.owner)
      @format = FactoryBot.create(:book_format)
      @owner = @shelf.owner
    end
    context 'book related scopes' do
      it 'shows the right shelves in the no_books scope' do
        Book.create(
          title: 'The Book',
          owner: @owner,
          book_format: @format,
          shelf: @shelf
        )
        Book.create(
          title: 'Another book',
          owner: @owner,
          book_format: @format
        )
        expect(Shelf.no_books).to include(@shelf2)
        expect(Shelf.no_books).to_not include(@shelf)
      end
    end
  end

end
# rubocop:enable Metrics/BlockLength
