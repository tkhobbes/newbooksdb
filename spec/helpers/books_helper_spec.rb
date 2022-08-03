# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the BooksHelper. For example:
#
# describe BooksHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end

# rubocop:disable Metrics/BlockLength
RSpec.describe BooksHelper, type: :helper do
  include ActionView::Helpers

  before(:all) do
    @book = create(:german_translation)
    @book2 = create(:hobbit)
  end

  context 'book view helpers' do
    it 'displays the original title in brackets' do
      expect(original_title(@book)).to eq('(The Lord of the Rings)')
    end

    it 'shows filled svg icons for the book rating' do
      expect(
        rating_stars(
          @book.rating_before_type_cast
        ).scan(
          'fill="currentColor"'
        ).size).to eq(@book.rating_before_type_cast)
    end

    it 'shows a picture when a cover is attached' do
      expect(cover_image(@book2)).to include('img')
    end

    it 'shows an svg when no cover is attached' do
            expect(cover_image(@book)).to include('svg')
    end

    it 'displays the synopsis if there is one' do
      expect(book_synopsis(@book2)).to include('<p>')
    end

    it 'does not display anything if there is no synopsis' do
      expect(book_synopsis(@book)).to eq(nil)
    end
  end
end
# rubocop:enable Metrics/BlockLength
