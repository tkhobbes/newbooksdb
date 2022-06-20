require 'rails_helper'

RSpec.describe Book, type: :model do

  context 'validation tests' do
    it 'is not valid without title' do
      book = Book.new(year: 1937)
      expect(book.valid?).to eq(false)
    end

    it 'is valid with title' do
      book = Book.new(title: 'The Hobbit')
      expect(book.valid?).to eq(true)
    end
  end

  context 'logic tests' do
    it 'removes prefixing words from sort_title' do
      book = Book.create(title: 'The Hobbit', year: 1937)
      expect(book.sort_title).to eq('hobbit')
      book2 = Book.create(title: 'A wonderful story', year: 1937)
      expect(book2.sort_title).to eq('wonderful story')
      book3 = Book.create(title: 'An Unexpected Truth', year: 2000)
      expect(book3.sort_title).to eq('unexpected truth')
    end

    it 'defaults to not rated' do
      book = Book.new(title: 'The Hobbit')
      expect(book.rating).to eq('not_rated')
    end

      it 'translates rating to text' do
        book = Book.new(title: 'The Hobbit', rating: 5)
        expect(book.rating).to eq('favourite')
      end

      it 'responds to rated?' do
        book = Book.new(title: 'The Hobbit', rating: 5)
        expect(book.rated?).to eq(true)
      end

      it 'responds to not rated?' do
        book = Book.new(title: 'The Hobbit')
        expect(book.rated?).to eq(false)
      end

      it 'defaults to condition none' do
        book = Book.new(title: 'The Hobbit')
        expect(book.condition).to eq('not_given')
      end

      it 'translates condition to text' do
        book = Book.new(title: 'The Hobbit', condition: 5)
        expect(book.condition).to eq('like_new')
      end
  end

end
