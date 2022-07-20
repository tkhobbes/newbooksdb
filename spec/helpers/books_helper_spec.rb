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
RSpec.describe BooksHelper, type: :helper do
  include ActionView::Helpers

  before(:all) do
    @book = create(:german_translation)
  end

  context 'book view helpers' do
    it 'displays the original title in brackets' do
      expect(original_title(@book)).to eq('(The Lord of the Rings)')
    end

    it 'shows filled svg icons for the book rating' do
      expect(rating_stars(@book.rating_before_type_cast).scan('fill="currentColor"').size).to eq(@book.rating_before_type_cast)
    end
  end
end
