# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookFormat do
  let(:fallback_format) { create(:fallback_format) }

  describe 'Fallback' do
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
