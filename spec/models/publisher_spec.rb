# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Publisher, type: :model do
  describe 'validations' do
    before do
      @publisher = FactoryBot.create(:publisher)
    end
    context 'uniqueness' do
      it 'cannot have two publishers with the same name' do
        publisher = Publisher.new(name: 'Books Inc.')
        expect(publisher).not_to be_valid
      end
    end # uniqueness context
  end # validations

  describe 'slugs' do
    before do
      @publisher = FactoryBot.create(:publisher)
    end

    context 'slug based on name' do
      it 'creates a slug when saving' do
        expect(@publisher.slug).to eq('books-inc')
      end

      it 'updates a slug when the name is changed' do
        @publisher.update!(name: 'ABC Books')
        expect(@publisher.reload.slug).to eq('abc-books')
      end
    end # slug based on name
  end # slugs

end
# rubocop:enable Metrics/BlockLength
