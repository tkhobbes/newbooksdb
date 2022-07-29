# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'books/new.html.erb', type: :view do

  before(:all) do
    @book = create(:hobbit)
  end

  context 'Create book page' do
    it 'says "add a new book" on the new page' do
      render
      expect(rendered).to include 'Add a new book'
    end
  end
end
