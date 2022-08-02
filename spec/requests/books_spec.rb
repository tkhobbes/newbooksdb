# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe BooksController, type: :controller do

  before(:all) do
    @book = create(:hobbit)
    @book2 = create(:a_prefix_book)
  end

  context 'Basic book routes' do
    describe 'GET /show' do
      it 'returns http success' do
        get :show, params: { id: @book.to_param }
        expect(response).to have_http_status(200)
      end

      describe 'DELETE /destroy' do
        it 'deletes a book' do
          delete :destroy, params: { id: @book.to_param }
          expect(response).to have_http_status(303)
        end
      end

      describe 'CREATE /new' do
        it 'creates a book when the title and format is present' do
          post :create, params: { book: { title: 'A new book', book_format_id: '0' } }
          expect(response).to redirect_to(assigns(:book))
        end

        it 'does not create a book when the title is not present' do
          post :create, params: { book: { original_title: 'Not enough' } }
          expect(response).to render_template(:new)
        end
      end

      describe 'PATCH /update' do
        it 'updates a book' do
          patch :update, params: { id: @book.to_param, book: { title: 'A new title' } }
          expect(response).to redirect_to(assigns(:book))
        end

        it 'does not update when the title is deleted' do
          patch :update, params: { id: @book.to_param, book: { title: '' } }
          expect(response).to render_template(:edit)
        end
      end
    end

  end

end
# rubocop:enable Metrics/BlockLength
