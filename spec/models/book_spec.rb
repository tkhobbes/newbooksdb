require 'rails_helper'

RSpec.describe Book, type: :model do
  it 'does not allow to be stored' do
    book = Book.new(year: 1937)
    expect(book.valid?).to eq(false)
  end

  it 'removes prefixing words from sort_title' do
    book = Book.create(title: 'The Hobbit', year: 1937)
    expect(book.sort_title).to eq('hobbit')
    book2 = Book.create(title: 'A wonderful story', year: 1937)
    expect(book2.sort_title).to eq('wonderful story')
    book3 = Book.create(title: 'An Unexpected Truth', year: 2000)
    expect(book3.sort_title).to eq('unexpected truth')
  end

  it 'allows to be stored' do
    book = Book.new(title: 'The Hobbit')
    expect(book.valid?).to eq(true)
  end
end
