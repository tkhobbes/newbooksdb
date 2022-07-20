require 'rails_helper'

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
    end

  end

end
