# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shelf, type: :model do
  before(:all) do
    @book = create(:hobbit)
  end
  it 'shows the right shelf for a book' do
    expect(@book.shelf.name).to eq('Office tk')
  end
end
