# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Publisher do
  describe 'validations' do
    let!(:publisher) { create(:publisher) }

    context 'uniqueness' do
      it 'cannot have two publishers with the same name' do
        publisher = Publisher.new(name: 'Books Inc.')
        expect(publisher).not_to be_valid
      end
    end # uniqueness context
  end # validations

  describe 'slugs' do
    let(:publisher) { create(:publisher) }

    context 'slug based on name' do
      it 'creates a slug when saving' do
        expect(publisher.slug).to eq('books-inc')
      end

      it 'updates a slug when the name is changed' do
        publisher.update!(name: 'ABC Books')
        expect(publisher.reload.slug).to eq('abc-books')
      end
    end # slug based on name
  end # slugs

end
