require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  describe 'GET /show' do
    it 'returns http success' do
      book = Book.create(title: 'The Hobbit', year: 1937)
      get :show, params: { id: book.to_param }
      expect(response).to have_http_status(200)
    end
  end

end
