require 'rails_helper'

RSpec.describe "books/show.html.erb", type: :view do
  context 'Show page' do
    let(:book) { create(:hobbit) }

    it 'displays the book title on the show page' do
      assign(:book, book)
      render
      expect(rendered).to include(book.title)
    end
  end
end
