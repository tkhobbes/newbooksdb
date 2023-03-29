# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author do
  describe 'validations' do
    context 'uniqueness' do
      before do
        @author = create(:author)
      end

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
    end # uniqueness

    context 'presence' do
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
    end # presence
  end # validations

  describe 'ratings' do
    before do
      @author = create(:author)
      @author_rated = create(:author, first_name: 'Jane', rating: 5)
    end

    context 'responds to rating methods' do
      it 'has a default rating of not_rated' do
        expect(@author.rating).to eq('not_rated')
      end

      it 'responds to rated? with true if book is rated' do
        expect(@author_rated.rated?).to be(true)
      end

      it 'defaults to rated? false if book is not rated' do
        expect(@author.rated?).to be(false)
      end

    end # responds to rating methods
  end # ratings

  describe 'names and slugs' do
    before do
      @author = create(:author)
    end

    context 'sort name' do
      it 'creates a sort name upon save' do
        expect(@author.sort_name).to eq('Doe, John')
      end

      it 'updates the sort name if the first or last name is changed' do
        @author.update!(first_name: 'Jane')
        expect(@author.reload.sort_name).to eq('Doe, Jane')
      end

      it 'sets sort name to first name if only first name exists' do
        author = create(:author, first_name: 'Jane', last_name: nil)
        expect(author.sort_name).to eq('Jane')
      end

      it 'sets sort name to last name if only last name exists' do
        author = create(:author, first_name: nil, last_name: 'Doe')
        expect(author.sort_name).to eq('Doe')
      end

    end # sort name

    context 'display name' do
      it 'creates a display name upon save' do
        expect(@author.display_name).to eq('John Doe')
      end

      it 'updates the display name if the first or last name is changed' do
        @author.update!(first_name: 'Jane')
        expect(@author.reload.display_name).to eq('Jane Doe')
      end

      it 'sets display name to first name if only first name exists' do
        author = create(:author, first_name: 'Jane', last_name: nil)
        expect(author.display_name).to eq('Jane')
      end

      it 'sets display name to last name if only last name exists' do
        author = create(:author, first_name: nil, last_name: 'Doe')
        expect(author.display_name).to eq('Doe')
      end
    end # display name

    context 'name' do
      it 'responds to the name method' do
        expect(@author.name).to eq(@author.display_name)
      end
    end # name

    context 'slug' do
      it 'creates a slug based on the display name' do
        expect(@author.slug).to eq('john-doe')
      end

      it 'updates the slug if the name is changed' do
        @author.update!(first_name: 'Jane')
        expect(@author.reload.slug).to eq('jane-doe')
      end
    end # slug
  end # names

  describe 'helpers' do
    before do
      @author = create(:author, first_name: 'Jane', born: 50.years.ago.year)
      @dead_author = create(:author, born: 100.years.ago.year, died: 40.years.ago.year)
    end

    context 'dead, alive, and age' do
      it 'responds to dead? with true if author is dead' do
        expect(@dead_author.dead?).to be(true)
      end

      it 'responds to dead? with false if author is alive' do
        expect(@author.dead?).to be(false)
      end

      it 'calculates the age for a living actor' do
        expect(@author.age).to eq(50)
      end

      it 'calculates the age for a dead actor' do
        expect(@dead_author.age).to eq(60)
      end
    end
  end # helpers

  describe 'scopes' do
    before do
      @author1 = create(:author)
      @author2 = create(:author, first_name: 'Jane', born: 50.years.ago.year)
      @author3 = create(:author, last_name: 'Smith', born: 100.years.ago.year, died: 40.years.ago.year)
    end

    context 'search specific' do
      it 'responds to authors with a certain letter' do
        expect(Author.letter('d')).to include(@author1, @author2)
        expect(Author.letter('d')).not_to include(@author3)
      end
    end # search specific

    context 'other scopes' do
      before do
        Book.create(
          title: 'Test Book',
          book_format: create(:book_format),
          owner: create(:owner),
          authors: [ @author1 ]
        )
      end

      it 'responds to dead scope' do
        expect(Author.dead).to include(@author3)
        expect(Author.dead).not_to include(@author1, @author2)
      end

      it 'responds to alive scope' do
        expect(Author.alive).to include(@author1, @author2)
        expect(Author.alive).not_to include(@author3)
      end

      it 'responds to no_book scope' do
        expect(Author.no_books).to include(@author2, @author3)
        expect(Author.no_books).not_to include(@author1)
      end
    end # other scopes
  end # scopes

  describe 'cache counts' do
    before do
      @author = create(:author)
      @book = Book.create(
          title: 'Test Book',
          book_format: create(:book_format),
          owner: create(:owner),
          authors: [ @author ]
      )
    end

    it 'increases the book count on authors when a book is added' do
      expect(@author.books_count).to eq(1)
    end
  end # cache counts
end
