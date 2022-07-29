# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookCardComponent, type: :component do

  before(:all) do
    @book = create(:hobbit)
  end

  context 'Book Card Component' do
    it 'displays the book title in the book card component' do
      expect(
        render_inline(described_class.new(book: @book)).to_html
      ).to include(@book.title)
    end
  end

end
