require 'rails_helper'

RSpec.describe "books/index.html.erb", type: :view do

  before(:all) do
    @books = Array.new(3) { create(:random_book) }
  end

  context 'Index page' do
    it 'displays a book card' do
      assign(:books, @books)
      render
      expect(rendered).to include('bookcard-big')
    end
  end
end
