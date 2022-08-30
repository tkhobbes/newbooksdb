# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookFormat, type: :model do
  before(:all) do
    @book = create(:hobbit)
    @book_format_default = create(:not_defined)
  end

  it 'should reassign to the fallback book_format if their book_format is deleted' do
    format = @book.book_format
    format.destroy
    expect(@book.reload.book_format.id).to eq(@book_format_default.id)
  end

  it 'should not let the fallback format be deleted' do
    format = @book_format_default
    format.destroy
    expect(format).to be_truthy
  end

  it 'displays the proper book format for a book with that format' do
    expect(@book.book_format.name).to eq('Hardcover')
  end
end
