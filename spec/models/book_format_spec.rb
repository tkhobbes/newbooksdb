# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookFormat do
  let!(:fallback_format) { create(:fallback_format) }

  describe 'validations' do
    context 'name' do
      it 'must have a name' do
        format = BookFormat.new(name: nil)
        expect(format).not_to be_valid
      end

      it 'must have a unique name' do
        format = BookFormat.new(name: 'fallback')
        expect(format).not_to be_valid
      end
    end

    context 'book_count' do
      let(:owner) { create(:owner) }

      it 'has zero books by default' do
        expect(fallback_format.books_count).to eq 0
      end

      it 'increases book_count by 1 when adding a book with that format' do
        Book.create(
          title: 'The Hobbit',
          owner:,
          book_format: fallback_format
        )
        expect(fallback_format.books_count).to eq 1
      end
    end
  end

  describe 'Fallback' do
    context 'defaults' do
      it 'defaults fallback to false' do
        format = BookFormat.create(name: 'abc')
        expect(format.fallback).to be false
      end
    end

    context 'book realignment to fallbacks' do
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

      it 'moves books to the fallback format if the format is destroyed' do
        format.destroy
        expect(fallback_format.reload.books.count).to eq(3)
        expect(book.reload.book_format).to eq(fallback_format)
      end
    end # context book realignment to fallbacks

    context 'destroy format which is fallback' do
      it "doesn't let you destroy the book format which is defined as fallback" do
        fallback_format.destroy
        expect(fallback_format).to be_present
      end
    end

  end # describe Fallback

end
