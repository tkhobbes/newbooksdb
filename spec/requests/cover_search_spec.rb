# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CoverSearch' do
  describe 'authentication' do
    let(:profile) { create(:profile) }
    let(:format) { create(:fallback_format) }
    let(:book) do Book.create(
      title: 'The Hobbit',
      book_format: format,
      owner: profile.owner,
      isbn: '9780261103344'
    ) end

    context 'must log in' do
      it 'cannot search for a cover if not logged in' do
        post cover_search_create_path, params: {
          book_id: book.id,
          isbn: book.isbn
        }
        expect(book.reload.cover_searched).to be false
      end

      it 'can search for a cover if logged in' do
        sign_in profile.owner
        post cover_search_create_path, params: {
          book_id: book.id,
          isbn: book.isbn
        }
        expect(book.reload.cover_searched).to be true
      end
    end

  end
end
