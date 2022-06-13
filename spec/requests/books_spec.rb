require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/books/show"
      expect(response).to have_http_status(:success)
    end
  end

end
