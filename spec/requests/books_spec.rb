# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Books' do
  describe 'authentication' do
    let(:format) { create(:book_format) }
    let!(:profile) { create(:profile) }

    context 'not logged in' do
      it 'can see books index without login' do
        get books_path
        expect(response).to have_http_status(:success)
      end

      it 'can see books show without login' do
       book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner: profile.owner
        )
        get book_path(book.id)
        expect(response).to have_http_status(:success)
      end
    end

    context 'must log in' do
      it 'cannot create a book without being logged in' do
        post books_path, params: {
          book: {
            title: 'A totally random book',
            book_format: format,
            owner: profile.owner
          }
        }
        expect(Book.count).to eq(0)
      end

      it 'cannot update a book without being logged in' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner: profile.owner
        )
        patch book_path(book.id), params: {
          book: {
            title: 'new'
          }
        }
        expect(book.reload.title).to eq('The Hobbit')
      end

      it 'cannot delete a book without being logged in' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner: profile.owner
        )
        delete book_path(book.id)
        expect(Book.count).to eq(1)
      end
    end

    context 'has logged in' do

      it 'can create a book when logged in' do
        sign_in profile.owner
        # why do we need to have a fallback format here?
        # the book is not created with the proper format
        create(:fallback_format)
        post books_path, params: {
          book: {
            title: 'A totally random book',
            book_format: format,
            owner: profile.owner
          }
        }
        expect(Book.count).to eq(1)
      end

      it 'can update a book when logged in' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner: profile.owner
        )
        sign_in profile.owner
        patch book_path(book.id), params: {
          book: {
            title: 'bla'
          }
        }
        expect(book.reload.title).to eq('bla')
      end

      it 'can delete a book when logged in' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner: profile.owner
        )
        sign_in profile.owner
        delete book_path(book.id)
        expect(Book.count).to eq(0)
      end
    end
  end
end
