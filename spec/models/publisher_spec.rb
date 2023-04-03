# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Publisher do
  let!(:publisher) { create(:publisher) }

  describe 'validations' do
    subject { publisher }

    context 'when a publisher is created' do
      it 'cannot have two publishers with the same name' do
        publisher = Publisher.new(name: 'Books Inc.')
        expect(publisher).not_to be_valid
      end

      it 'requires a name' do
        invalid_publisher = Publisher.new(name: nil)
        expect(invalid_publisher).not_to be_valid
      end

      it 'creates a slug when saving' do
        expect(publisher.slug).to eq('books-inc')
      end

      it 'defaults to books_count = 0' do
        expect(publisher.books_count).to eq 0
      end
    end

    context 'when a book is created for a publisher' do
      it 'increases books_count' do
        Book.create(
          title: 'The Book',
          owner: create(:owner),
          book_format: create(:book_format),
          publisher:
        )
        expect(publisher.reload.books_count).to eq 1
      end
    end

    context 'when a name is changed' do
      let!(:another_publisher) { create(:publisher, name: 'ABC Books') }

      it 'updates a slug when the name is changed' do
        publisher.update!(name: 'My Books AG')
        expect(publisher.reload.slug).to eq('my-books-ag')
      end

      it 'does not allow to change the name to a name that already exists' do
        publisher.update(name: 'ABC Books')
        expect(publisher).not_to be_valid
      end
    end # context name is changed
  end # describe validations

end
