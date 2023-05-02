# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookFormat do
  let!(:fallback_format) { create(:fallback_format) }

  describe 'validations' do
    context 'when a book format is created' do
      it 'must have a name' do
        format = BookFormat.new(name: nil)
        expect(format).not_to be_valid
      end

      it 'must have a unique name' do
        format = BookFormat.new(name: 'fallback')
        expect(format).not_to be_valid
      end

      it 'has zero books by default' do
        expect(fallback_format.books_count).to be 0
      end

      it 'defaults fallback to false' do
        format = BookFormat.create(name: 'abc')
        expect(format.fallback).to be false
      end
    end

    context 'when a book is added with a format' do
      let(:owner) { create(:owner) }

      it 'increases book_count by 1 for the format' do
        Book.create(
          title: 'The Hobbit',
          owner:,
          book_format: fallback_format
        )
        expect(fallback_format.books_count).to be 1
      end
    end
  end

  describe 'Fallback' do

    context 'when a format is destroyed' do
        let!(:format) { create(:book_format) }
        let!(:owner) { create(:owner) }
        let!(:book) do
          Book.create(
            title: 'The Hobbit',
            book_format: format,
            owner:
          )
        end
        let!(:second_book) do
          Book.create(
            title: 'Book 2',
            book_format: format,
            owner:
          )
        end
        let!(:third_book) do
          Book.create(
            title: 'Book 3',
            book_format: fallback_format,
            owner:
          )
        end

      it 'moves books to the fallback format' do
        format.destroy
        expect(fallback_format.reload.books.count).to be 3
        expect(book.reload.book_format).to eq(fallback_format)
      end

      it "doesn't let you destroy the book format which is defined as fallback" do
        fallback_format.destroy
        expect(fallback_format).to be_present
      end
    end
  end
end
