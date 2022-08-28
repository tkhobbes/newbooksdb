require 'rails_helper'

RSpec.describe 'Hello World', type: :system do
  describe 'index page' do
    it 'shows the right content' do
      visit books_path
      expect(page).to have_content('Book Collector')
    end
  end
end
