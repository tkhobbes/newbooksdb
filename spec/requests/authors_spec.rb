# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authors' do
  describe 'authentication' do
    context 'not logged in' do
      it 'can see authors index without login' do
        get authors_path(locale: 'en')
        expect(response).to have_http_status(:success)
      end

      it 'can see authors show without login' do
        author = create(:author)
        get author_path(author.id, locale: 'en')
        expect(response).to have_http_status(:success)
      end
    end

    context 'must log in' do
      it 'cannot create an author without being logged in' do
        post authors_path, params: {
          author: {
            first_name: 'JRR',
            last_name: 'Tolkien'
          }
        }
        expect(Author.count).to eq(0)
      end

      it 'cannot update an author without being logged in' do
        author = create(:author)
        patch author_path(author.id, locale: 'en'), params: {
          author: {
            first_name: 'new'
          }
        }
        expect(author.reload.first_name).to eq('John')
      end

      it 'cannot delete an author without being logged in' do
        author = create(:author)
        delete author_path(author.id, locale: 'en')
        expect(Author.count).to eq(1)
      end
    end

    context 'has logged in' do
      let(:owner) { create(:owner) }

      it 'can create an author when logged in' do
        sign_in owner
        post authors_path, params: {
          author: {
            first_name: 'JRR',
            last_name: 'Tolkien'
          }
        }
        expect(Author.count).to eq(1)
      end

      it 'can update an author when logged in' do
        author = create(:author)
        sign_in owner
        patch author_path(author.id, locale: 'en'), params: {
          author: {
            first_name: 'new'
          }
        }
        expect(author.reload.first_name).to eq('new')
      end

      it 'can delete an author when logged in' do
        author = create(:author)
        sign_in owner
        delete author_path(author.id, locale: 'en')
        expect(Author.count).to eq(0)
      end
    end
  end
end
