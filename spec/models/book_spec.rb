# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Book, type: :model do

  before(:all) do
    @book_model = create(:hobbit)
    @book2_model = create(:a_prefix_book)
    @book_model_no_format = create(:random_book)
  end

  context 'titles and slugs' do
    it 'removes prefixing words from sort_title' do
      expect(@book_model.sort_title).to eq('hobbit')
      expect(@book2_model.sort_title).to eq('wonderful life of an ant')
    end

    it 'has a slug' do
      expect(@book_model.slug).to eq('the-hobbit')
    end
  end

  context 'ENUMs' do
    it 'defaults to not rated' do
      expect(@book2_model.rating).to eq('not_rated')
    end

    it 'translates rating to text' do
      expect(@book_model.rating).to eq('favourite')
    end

    it 'responds to rated? with true if book is rated' do
      expect(@book_model.rated?).to eq(true)
    end

    it 'responds to rated? with false if book is not rated' do
      expect(@book2_model.rated?).to eq(false)
    end

    it 'defaults to condition "not_given"' do
      expect(@book2_model.condition).to eq('not_given')
    end

    it 'translates condition to text' do
      expect(@book_model.condition).to eq('used_ok')
    end
  end

end
# rubocop:enable Metrics/BlockLength
