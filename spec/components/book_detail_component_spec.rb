# frozen_string_literal: true

require "rails_helper"

RSpec.describe BookDetailComponent, type: :component do

  before(:all) do
    @book = create(:hobbit)
  end

  context 'Book Detail Component' do
    it 'displays the book title on the detail component' do
      expect(
        render_inline(described_class.new(book: @book)).to_html
      ).to include(@book.title)
    end
  end

end
