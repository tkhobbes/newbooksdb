# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre do
  let!(:genre) { create(:genre) }
  let!(:another_genre) { create(:genre, name: 'Arbitrary') }
  let!(:empty_genre) { create(:genre, name: 'Empty') }
  let!(:format) { create(:book_format) }
  let!(:owner) { create(:owner) }
  let!(:book) do
    Book.create(
      title: 'The Hobbit',
      book_format: format,
      owner:,
      genres: [ genre ]
    )
  end
  let!(:second_book) do
    Book.create(
      title: 'The Hound of Baskerville',
      book_format: format,
      owner:,
      genres: [ genre ]
    )
  end
  let!(:third_book) do
    Book.create(
      title: 'The Lord of the Rings',
      book_format: format,
      owner:,
      genres: [ another_genre ]
    )
  end
  let!(:fourth_book) do
    Book.create(
      title: 'The Silmarillion',
      book_format: format,
      owner:,
      genres: [ genre, another_genre ]
    )
  end

  describe 'validations' do
    context 'names' do
      it 'must have a name' do
        g = Genre.new(name: nil)
        expect(g).not_to be_valid
      end

      it 'must have a unique name' do
        g = Genre.new(name: 'Arbitrary')
        expect(g).not_to be_valid
      end
    end
  end

  describe 'scopes' do
    context 'scopes with books' do
      it 'shows no books for genres with no books' do
        empty_genres = Genre.no_books
        expect(empty_genres).to include(empty_genre)
        expect(empty_genres).not_to include(genre)
      end

      it 'shows genres with the correct letter for letter scope' do
        a_genres = Genre.letter('a')
        expect(a_genres).to include(another_genre)
        expect(a_genres).not_to include(empty_genre)
      end
    end # context 'scopes with books'
  end # describe 'scopes'

  describe 'slugs and caching' do
    context 'slugs' do
      it 'creates a slug based on the genre name' do
        expect(another_genre.slug).to eq('arbitrary')
      end
    end # context 'slugs'

    context 'counter-caches' do
      it 'increases the books_count on genre if a book is added to that genre' do
        expect(genre.books_count).to eq(3)
        Book.create(
          title: 'another book',
          owner:,
          book_format: format,
          genres: [ genre ]
        )
        expect(genre.reload.books_count).to eq(4)
      end
    end # context 'counter-caches'
  end # describe 'slugs'

end
