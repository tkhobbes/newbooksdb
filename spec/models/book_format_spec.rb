# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookFormat do
  describe 'Fallback' do
    before do
      @fallback_format = create(:fallback_format)
    end

    context 'book realignment to fallbacks' do
      before do
        @format = create(:book_format)
        @owner = create(:owner)
        @book = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        @second_book = Book.create(
          title: 'Book 2',
          book_format: @format,
          owner: @owner
        )
        @third_book = Book.create(
          title: 'Book 3',
          book_format: @fallback_format,
          owner: @owner
        )
      end

      it 'moves books to the fallback format if the format is destroyed' do
        @format.destroy
        expect(@fallback_format.reload.books.count).to eq(3)
        expect(@book.reload.book_format).to eq(@fallback_format)
      end
    end # context book realignment to fallbacks

    context 'destroy format which is fallback' do
      it "doesn't let you destroy the book format which is defined as fallback" do
        @fallback_format.destroy
        expect(@fallback_format).to be_present
      end
    end

  end # describe Fallback

end
