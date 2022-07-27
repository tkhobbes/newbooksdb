require 'rails_helper'

 include Pagy::Backend

RSpec.describe "books/index.html.erb", type: :view do

  before(:all) do
    @pagy, @books = pagy(Array.new(3) { create(:random_book) })
  end

  context 'Index page' do
    it 'displays a book card' do
      assign(:books, @books)
      assign(:pagy, @pagy)
      render
      expect(rendered).to include('bookcard-big')
    end
  end
end
