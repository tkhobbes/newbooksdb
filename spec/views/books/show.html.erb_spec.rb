require 'rails_helper'

RSpec.describe "books/show.html.erb", type: :view do

  before(:all) do
    @book = create(:hobbit)
    @book2 = create(:a_prefix_book)
  end

  context 'Show page' do
    it 'displays the book title on the show page' do
      assign(:book, @book)
      render
      expect(rendered).to include(@book.title)
    end
  end
end
