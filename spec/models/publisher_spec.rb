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

    context 'presence and defaults' do
      it 'requires a name' do
        invalid_publisher = Publisher.new(name: nil)
        expect(invalid_publisher).not_to be_valid
      end

      it 'defaults to books_count = 0' do
        expect(publisher.books_count).to eq 0
      end

      it 'increases books_count when a book is added' do
        Book.create(
          title: 'The Book',
          owner: create(:owner),
          book_format: create(:book_format),
          publisher:
        )
        expect(publisher.reload.books_count).to eq 1
      end
    end
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
