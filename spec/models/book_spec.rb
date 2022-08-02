# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Book, type: :model do

  before(:all) do
    @book = create(:hobbit)
    @book2 = create(:a_prefix_book)
  end

  context 'validation tests' do
    it 'is not valid without title' do
      book = Book.new(year: 1937)
      expect(book.valid?).to eq(false)
    end

    it 'is valid with title' do
      book = Book.new(title: 'The Hobbit', book_format_id: 1)
      expect(book.valid?).to eq(true)
    end
  end

  context 'logic tests' do
    it 'removes prefixing words from sort_title' do
      expect(@book.sort_title).to eq('hobbit')
      expect(@book2.sort_title).to eq('wonderful life of an ant')
    end

    it 'defaults to not rated' do
      expect(@book2.rating).to eq('not_rated')
    end

      it 'translates rating to text' do
        expect(@book.rating).to eq('favourite')
      end

      it 'responds to rated?' do
        expect(@book.rated?).to eq(true)
      end

      it 'responds to not rated?' do
        expect(@book2.rated?).to eq(false)
      end

      it 'defaults to condition none' do
        expect(@book2.condition).to eq('not_given')
      end

      it 'translates condition to text' do
        expect(@book.condition).to eq('used_ok')
      end

      it 'has a slug' do
        expect(@book.slug).to eq('the-hobbit')
      end
  end

end
# rubocop:enable Metrics/BlockLength
