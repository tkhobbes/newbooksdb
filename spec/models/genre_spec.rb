# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Genre, type: :model do
  before do
    @genre = FactoryBot.create(:genre)
    @another_genre = FactoryBot.create(:genre, name: 'Arbitrary')
    @empty_genre = FactoryBot.create(:genre, name: 'Empty')
    @format = FactoryBot.create(:book_format)
    @owner = FactoryBot.create(:owner)
    @book = Book.create(
      title: 'The Hobbit',
      book_format: @format,
      owner: @owner,
      genres: [ @genre ]
    )
    @second_book = Book.create(
      title: 'The Hound of Baskerville',
      book_format: @format,
      owner: @owner,
      genres: [ @genre ]
    )
    @third_book = Book.create(
      title: 'The Lord of the Rings',
      book_format: @format,
      owner: @owner,
      genres: [ @another_genre ]
    )
    @fourth_book = Book.create(
      title: 'The Silmarillion',
      book_format: @format,
      owner: @owner,
      genres: [ @genre, @another_genre ]
    )
  end

  describe 'scopes' do
    context 'scopes with books' do
      it 'shows no books for genres with no books' do
        empty_genres = Genre.no_books
        expect(empty_genres).to include(@empty_genre)
        expect(empty_genres).not_to include(@genre)
      end

      it 'shows genres with the correct letter for letter scope' do
        a_genres = Genre.letter('a')
        expect(a_genres).to include(@another_genre)
        expect(a_genres).not_to include(@empty_genre)
      end
    end # context 'scopes with books'
  end # describe 'scopes'

  describe 'slugs and caching' do
    context 'slugs' do
      it 'creates a slug based on the genre name' do
        expect(@another_genre.slug).to eq('arbitrary')
      end
    end # context 'slugs'

    context 'counter-caches' do
      it 'increases the books_count on genre if a book is added to that genre' do
        expect(@genre.books_count).to eq(3)
        Book.create(
          title: 'another book',
          owner: @owner,
          book_format: @format,
          genres: [ @genre ]
        )
        expect(@genre.reload.books_count).to eq(4)
      end
    end # context 'counter-caches'
  end # describe 'slugs'

end
# rubocop:enable Metrics/BlockLength
