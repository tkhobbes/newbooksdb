# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author do
  describe 'validations' do
    subject { author }

    let!(:author) { create(:author) }


    context 'when an author is created' do
      it 'allows two authors with the same last name if first name is different' do
        another_author = Author.new(first_name: 'Jane', last_name: 'Doe')
        expect(another_author).to be_valid
      end

      it 'allows two authors with the same first name if last name is different' do
        another_author = Author.new(first_name: 'John', last_name: 'Smith')
        expect(another_author).to be_valid
      end

      it 'does not allow two authors with the same first and last name' do
        another_author = Author.new(first_name: 'John', last_name: 'Doe')
        expect(another_author).not_to be_valid
      end

      it 'is valid if it only has a first name' do
        author = Author.new(first_name: 'John', last_name: nil)
        expect(author).to be_valid
      end

      it 'is valid if it only has a last name' do
        author = Author.new(first_name: nil, last_name: 'Doe')
        expect(author).to be_valid
      end

      it 'is invalid if it has neither a first nor a last name' do
        author = Author.new(first_name: nil, last_name: nil)
        expect(author).not_to be_valid
      end

      it 'creates a sort name upon save' do
        expect(author.sort_name).to eq('Doe, John')
      end

      it 'sets sort name to first name if only first name exists' do
        another_author = create(:author, first_name: 'Jane', last_name: nil)
        expect(another_author.sort_name).to eq('Jane')
      end

      it 'sets sort name to last name if only last name exists' do
        another_author = create(:author, first_name: nil, last_name: 'Doe')
        expect(another_author.sort_name).to eq('Doe')
      end

      it 'creates a display name upon save' do
        expect(author.display_name).to eq('John Doe')
      end

      it 'sets display name to first name if only first name exists' do
        another_author = create(:author, first_name: 'Jane', last_name: nil)
        expect(another_author.display_name).to eq('Jane')
      end

      it 'sets display name to last name if only last name exists' do
        another_author = create(:author, first_name: nil, last_name: 'Doe')
        expect(another_author.display_name).to eq('Doe')
      end

      it 'creates a slug based on the display name' do
        expect(author.slug).to eq('john-doe')
      end
    end

    context 'when an author is changed' do
      it 'updates the sort name if the first or last name is changed' do
        author.update!(first_name: 'Jane')
        expect(author.reload.sort_name).to eq('Doe, Jane')
      end

      it 'updates the display name if the first or last name is changed' do
        author.update!(first_name: 'Jane')
        expect(author.reload.display_name).to eq('Jane Doe')
      end

      it 'updates the slug if the name is changed' do
        author.update!(first_name: 'Jane')
        expect(author.reload.slug).to eq('jane-doe')
      end
    end

    context 'when a book is added for an author' do
      let!(:book) do
        Book.create(
          title: 'Test Book',
          book_format: create(:book_format),
          owner: create(:owner),
          authors: [ author ]
        )
      end

      it 'increases the book count on authors when a book is added' do
        expect(author.books_count).to eq(1)
      end
    end
  end # validations

  describe '#ratings' do
    subject { author }

    let(:author) { create(:author) }
    let(:author_rated) {create(:author, first_name: 'Jane', rating: 5) }


    context 'when using rating methods' do
      it 'has a default rating of not_rated' do
        expect(author.rating).to eq('not_rated')
      end

      it 'responds to rated? with true if book is rated' do
        expect(author_rated.rated?).to be(true)
      end

      it 'defaults to rated? false if book is not rated' do
        expect(author.rated?).to be(false)
      end

    end # responds to rating methods
  end # ratings

  describe 'model methods' do
    subject { author }

    let(:author) { create(:author, first_name: 'Jane', born: 50.years.ago.year) }


    context 'name method' do
      it 'responds to the name method' do
        expect(author.name).to eq(author.display_name)
      end
    end # name

    context 'dead, alive, and age methods' do
      let(:dead_author) { create(:author, born: 100.years.ago.year, died: 40.years.ago.year) }

      it 'responds to dead? with true if author is dead' do
        expect(dead_author.dead?).to be(true)
      end

      it 'responds to dead? with false if author is alive' do
        expect(author.dead?).to be(false)
      end

      it 'calculates the age for a living actor' do
        expect(author.age).to eq(50)
      end

      it 'calculates the age for a dead actor' do
        expect(dead_author.age).to eq(60)
      end
    end
  end # helpers

  describe 'scopes' do
    subject { author1 }

    let(:author1) { create(:author) }
    let(:author2) { create(:author, first_name: 'Jane', born: 50.years.ago.year) }
    let(:author3) { create(:author, last_name: 'Smith', born: 100.years.ago.year, died: 40.years.ago.year) }


    context 'when searching for authors' do
      it 'responds to authors with a certain letter' do
        expect(Author.letter('d')).to include(author1, author2)
        expect(Author.letter('d')).not_to include(author3)
      end
    end # search specific

    context 'other scopes' do
      before do
        Book.create(
          title: 'Test Book',
          book_format: create(:book_format),
          owner: create(:owner),
          authors: [ author1 ]
        )
      end

      it 'responds to dead scope' do
        expect(Author.dead).to include(author3)
        expect(Author.dead).not_to include(author1, author2)
      end

      it 'responds to alive scope' do
        expect(Author.alive).to include(author1, author2)
        expect(Author.alive).not_to include(author3)
      end

      it 'responds to no_book scope' do
        expect(Author.no_books).to include(author2, author3)
        expect(Author.no_books).not_to include(author1)
      end
    end # other scopes
  end # scopes

  describe 'cache counts' do

  end # cache counts
end
