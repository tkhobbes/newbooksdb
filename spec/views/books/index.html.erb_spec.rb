# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'books/index.html.erb', type: :view do
  include Pagy::Backend

  before(:all) do
    3.times { FactoryBot.create(:random_book) }
    @pagy, @books = pagy(Book.all)
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
