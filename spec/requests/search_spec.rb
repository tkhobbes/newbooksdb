# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search' do
  it 'can access the search index' do
    owner = create(:owner)
    format = create(:book_format)
    Book.create(
      title: 'The Hobbit',
      book_format: format,
      owner:
    )
    get search_index_path, params: { query: 'hobbit' }
    expect(response).to have_http_status(:success)
  end

  it 'can access the quick search menu' do
    get quicksearch_path, params: { query: 'hobbit' }, as: :turbo_stream
    expect(response.media_type).to eq Mime[:turbo_stream]
  end
end
