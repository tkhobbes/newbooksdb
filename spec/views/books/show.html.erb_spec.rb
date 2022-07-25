require 'rails_helper'

RSpec.describe "books/show.html.erb", type: :view do

  before(:all) do
    @book = create(:hobbit)
  end

  context 'Book detail page' do
    it 'displays the book title on the show page' do
      render
      expect(rendered).to include(@book.title)
    end
  end
end
