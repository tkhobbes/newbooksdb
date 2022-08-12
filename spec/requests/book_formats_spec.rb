# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookFormatsController, type: :controller do
  before(:all) do
    @book_format_default = create(:not_defined)
    @book = create(:hobbit)
  end

  it 'should not let the fallback format be deleted' do
    delete :destroy, params: { id: @book_format_default.id }
    expect(BookFormat.find(@book_format_default.id)).to be_truthy
  end

end
