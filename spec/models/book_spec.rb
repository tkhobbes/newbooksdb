# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Book, type: :model do
  describe 'Validations' do
    before do
      @format = BookFormat.create(name: 'default')
      @owner = Owner.create(email: 'john@doe.com', password: 'password')
    end

    context 'owners and identifiers' do
      it 'allows only one book with the same identifier by owner' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        second_book = Book.new(
          title: 'Book 2',
          book_format: @format,
          owner: @owner,
          identifier: book.identifier
        )
        second_book.valid?
        expect(second_book.errors[:identifier]).to include('has already been taken')
      end

      it 'allows books with the same identifier if owners differ' do
        second_owner = Owner.create(email: 'jane@doe.com', password: 'password')
        book = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        second_book = Book.new(
          title: 'Book 2',
          book_format: @format,
          owner: second_owner,
          identifier: book.identifier
        )
        expect(second_book).to be_valid
      end
    end # Context owners and identifiers

    context 'owners and ISBNs' do
      it 'allows only one book with the same ISBN by owner' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        second_book = Book.new(
          title: 'Book 2',
          book_format: @format,
          owner: @owner,
          isbn: book.isbn
        )
        second_book.valid?
        expect(second_book.errors[:isbn]).to include('has already been taken')
      end

      it 'allows books with the same ISBN if owners differ' do
        second_owner = Owner.create(email: 'jane@doe.com', password: 'password')
        book = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        second_book = Book.new(
          title: 'Book 2',
          book_format: @format,
          owner: second_owner,
          identifier: book.isbn
        )
        expect(second_book).to be_valid
      end
    end # Context owners and ISBNs

    context 'uniqueness validations' do
      it 'is not valid if book_format is missing' do
        book = Book.new(title: 'The Hobbit', owner: @owner)
        book.valid?
        expect(book.errors[:book_format_id]).to include("can't be blank")
      end

      it 'is it not valid if the title is missing' do
        book = Book.new(book_format: @format, owner: @owner)
        book.valid?
        expect(book.errors[:title]).to include("can't be blank")
      end

      it 'is not valid if the owner is missing' do
        book = Book.new(title: 'The Hobbit', book_format: @format)
        book.valid?
        expect(book.errors[:owner]).to include('must exist')
      end

      it 'is valid if a title, a owner and a format are given' do
        book = Book.new(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        expect(book).to be_valid
      end
    end # Context uniqueness validations
  end # Describe validations

  describe 'Ratings and Conditions' do
    before do
      @format = BookFormat.create(name: 'default')
      @owner = Owner.create(email: 'john@doe.com', password: 'password')
    end
    context 'Ratings' do
      it 'has a default rating of not_rated' do
        book = Book.new(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        expect(book.rating).to eq('not_rated')
      end

      it 'responds to rated? with true if book is rated' do
        book = Book.new(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner,
          rating: 5
        )
        expect(book.rated?).to eq(true)
      end
      it 'defaults to rated? false if book is not rated' do
        book = Book.new(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner,
        )
        expect(book.rated?).to eq(false)
      end
    end # Context Ratings

    context 'conditions' do
      it 'has a default condition of not_given' do
        book = Book.new(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        expect(book.condition).to eq('not_given')
      end
    end # Context conditions
  end # Describe Ratings and Conditions

  describe 'Titles and slugs' do
    before do
      @format = BookFormat.create(name: 'default')
      @owner = Owner.create(email: 'john@doe.com', password: 'password')
    end
    context 'Titles' do
      it 'removes prefixes from the sort title' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner,
        )
        expect(book.sort_title).to eq('hobbit')
      end
    end # Context Titles

    context 'slugs' do
      it 'creates a slug from the title' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner,
        )
        expect(book.slug).to eq('the-hobbit')
      end
    end # Context slugs
  end # Describe Titles and slugs

  describe 'identifiers, ISBNs and IDs are created properly' do
    before do
      @format = BookFormat.create(name: 'default')
      @owner = Owner.create(email: 'john@doe.com', password: 'password')
    end

    context 'identifiers' do
      it 'checks the identifier and does not change if it existing' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner,
          identifier: 'abc123-4'
        )
        expect(book.identifier).to eq('abc123-4')
      end

      it 'checks the identifier and creates one if not existing' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        expect(book.identifier[0]).to eq(@owner.id.to_s[0])
      end
    end # Context identifiers

    context 'ISBNs' do
      it 'checks the ISBN and does not change if it is existing' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner,
          isbn: '9783161484100'
        )
        expect(book.isbn).to eq('9783161484100')
      end

      it 'checks the ISBN and creates one if it is not existing' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        expect(book.isbn[0..6]).to eq("dummy-#{@owner.id.to_s[0]}")
      end
    end # Context ISBNs
  end # Describe identifiers, ISBNs and IDs are created properly

  describe 'scopes display the right books' do
    before do
      @format = BookFormat.create(name: 'default')
      @owner = Owner.create(email: 'john@doe.com', password: 'password')
    end

    context 'Owner scopes' do
      it "shows a owner's books as 'my books'" do
        owner2 = Owner.create(email: 'jane@doe.com', password: 'password')
        book1 = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        book2 = Book.create(
          title: 'The Lord of the Rings',
          book_format: @format,
          owner: @owner
        )
        book3 = Book.create(
          title: 'The Silmarillion',
          book_format: @format,
          owner: owner2
        )
        expect(Book.my_books(@owner)).to include(book1, book2)
        expect(Book.my_books(@owner)).not_to include(book3)
      end
    end # Context Owner scopes

    context 'shelf scopes' do
      it 'shows books of a certain shelf' do
        shelf1 = Shelf.create(name: 'Shelf 1', owner: @owner)
        shelf2 = Shelf.create(name: 'Shelf 2', owner: @owner)
        book1 = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner,
          shelf: shelf1
        )
        book2 = Book.create(
          title: 'The Lord of the Rings',
          book_format: @format,
          owner: @owner,
          shelf: shelf1
        )
        book3 = Book.create(
          title: 'The Silmarillion',
          book_format: @format,
          owner: @owner,
          shelf: shelf2
        )
        expect(Book.shelf_books(shelf1)).to include(book1, book2)
        expect(Book.shelf_books(shelf1)).not_to include(book3)
      end

      it 'displays books without a shelf' do
        shelf = Shelf.create(name: 'Shelf 1', owner: @owner)
        book1 = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner,
        )
        book2 = Book.create(
          title: 'The Lord of the Rings',
          book_format: @format,
          owner: @owner,
        )
        book3 = Book.create(
          title: 'The Silmarillion',
          book_format: @format,
          owner: @owner,
          shelf:
        )
        expect(Book.no_shelf).to include(book1, book2)
        expect(Book.no_shelf).not_to include(book3)
      end
    end # Context shelf scopes

    context 'letter scopes' do
      it 'displays books with a certain letter' do
        book1 = Book.create(
          title: 'The Hobbit',
          book_format: @format,
          owner: @owner
        )
        book2 = Book.create(
          title: 'The Hound of Baskerville',
          book_format: @format,
          owner: @owner,
        )
        book3 = Book.create(
          title: 'The Silmarillion',
          book_format: @format,
          owner: @owner,
        )
        expect(Book.letter('h')).to include(book1, book2)
        expect(Book.letter('h')).not_to include(book3)
      end
    end # Context letter scopes
  end # Describe scopes display the right books
end
# rubocop:enable Metrics/BlockLength
