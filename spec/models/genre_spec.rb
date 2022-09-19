require 'rails_helper'

RSpec.describe Genre, type: :model do
  before(:all) do
    @book = create(:hobbit)
  end

  it 'displays the proper genre for a book with that genre' do
    expect(@book.genres.first.name).to eq('Fiction')
  end
end
