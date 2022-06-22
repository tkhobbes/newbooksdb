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
  context 'book view helpers' do
    let(:book) { create(:german_translation) }

    it 'displays the original title in brackets' do
      expect(original_title(book)).to eq('(The Lord of the Rings)')
    end
  end
end
