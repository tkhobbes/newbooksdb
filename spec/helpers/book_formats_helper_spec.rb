# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the BookFormatsHelper. For example:
#
# describe BookFormatsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe BookFormatsHelper, type: :helper do
  before(:all) do
    @book_format = create(:not_defined)
  end
  it 'displays "(default)" if format is defined as fallback' do
    expect(is_fallback(@book_format)).to eq(' (default)')
  end
end
