require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  context 'Basic book routes' do
    let(:book) { create(:hobbit) }

    describe 'GET /show' do
      it 'returns http success' do
        get :show, params: { id: book.to_param }
        expect(response).to have_http_status(200)
      end
    end

  end

end
