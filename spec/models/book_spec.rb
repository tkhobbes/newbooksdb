# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Book, type: :model do
  context 'Validations' do
    it 'allows only one book with the same identifier by owner' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:
      )
      second_book = Book.new(
        title: 'Book 2',
        book_format: format,
        owner:,
        identifier: book.identifier
      )
      second_book.valid?
      expect(second_book.errors[:identifier]).to include('has already been taken')
    end

    it 'allows books with the same identifier if owners differ' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      second_owner = Owner.create(email: 'jane@doe.com', password: 'password')
      book = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:
      )
      second_book = Book.new(
        title: 'Book 2',
        book_format: format,
        owner: second_owner,
        identifier: book.identifier
      )
      expect(second_book).to be_valid
    end

    it 'allows only one book with the same ISBN by owner' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:
      )
      second_book = Book.new(
        title: 'Book 2',
        book_format: format,
        owner:,
        isbn: book.isbn
      )
      second_book.valid?
      expect(second_book.errors[:isbn]).to include('has already been taken')
    end

    it 'allows books with the same ISBN if owners differ' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      second_owner = Owner.create(email: 'jane@doe.com', password: 'password')
      book = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:
      )
      second_book = Book.new(
        title: 'Book 2',
        book_format: format,
        owner: second_owner,
        identifier: book.isbn
      )
      expect(second_book).to be_valid
    end

    it 'is not valid if book_format is missing' do
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.new(title: 'The Hobbit', owner:)
      book.valid?
      expect(book.errors[:book_format_id]).to include("can't be blank")
    end

    it 'is it not valid if the title is missing' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.new(book_format: format, owner:)
      book.valid?
      expect(book.errors[:title]).to include("can't be blank")
    end

    it 'is not valid if the owner is missing' do
      format = BookFormat.create(name: 'default')
      book = Book.new(title: 'The Hobbit', book_format: format)
      book.valid?
      expect(book.errors[:owner]).to include('must exist')
    end

    it 'is valid if a title, a owner and a format are given' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.new(
        title: 'The Hobbit',
        book_format: format,
        owner:
      )
      expect(book).to be_valid
    end
  end

  context 'Ratings and Conditions' do
    it 'has a default condition of not_given' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.new(
        title: 'The Hobbit',
        book_format: format,
        owner:
      )
      expect(book.condition).to eq('not_given')
    end

    it 'has a default rating of not_rated' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.new(
        title: 'The Hobbit',
        book_format: format,
        owner:
      )
      expect(book.rating).to eq('not_rated')
    end
    it 'responds to rated? with true if book is rated' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.new(
        title: 'The Hobbit',
        book_format: format,
        owner:,
        rating: 5
      )
      expect(book.rated?).to eq(true)
    end
    it 'defaults to rated? false if book is not rated' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.new(
        title: 'The Hobbit',
        book_format: format,
        owner:,
      )
      expect(book.rated?).to eq(false)
    end
  end

  context 'Titles and slugs are created properly from the Book Title' do
    it 'removes prefixes from the sort title' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:,
      )
      expect(book.sort_title).to eq('hobbit')
    end

    it 'creates a slug from the title' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:,
      )
      expect(book.slug).to eq('the-hobbit')
    end
  end

  context 'identifiers, ISBNs and IDs are created properly' do
    it 'checks the identifier and does not change if it existing' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:,
        identifier: 'abc123-4'
      )
      expect(book.identifier).to eq('abc123-4')
    end

    it 'checks the identifier and creates one if not existing' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:
      )
      expect(book.identifier[0]).to eq(owner.id.to_s[0])
    end

    it 'checks the ISBN and does not change if it is existing' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:,
        isbn: '9783161484100'
      )
      expect(book.isbn).to eq('9783161484100')
    end

    it 'checks the ISBN and creates one if it is not existing' do
      format = BookFormat.create(name: 'default')
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      book = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:
      )
      expect(book.isbn[0..6]).to eq("dummy-#{owner.id.to_s[0]}")
    end
  end

  context 'scopes display the right books' do
    it "shows a owner's books as 'my books'" do
      owner1 = Owner.create(email: 'john@doe.com', password: 'password')
      owner2 = Owner.create(email: 'jane@doe.com', password: 'password')
      format = BookFormat.create(name: 'default')
      book1 = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner: owner1
      )
      book2 = Book.create(
        title: 'The Lord of the Rings',
        book_format: format,
        owner: owner1
      )
      book3 = Book.create(
        title: 'The Silmarillion',
        book_format: format,
        owner: owner2
      )
      expect(Book.my_books(owner1)).to include(book1, book2)
      expect(Book.my_books(owner1)).not_to include(book3)
    end

    it 'shows books of a certain shelf' do
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      shelf1 = Shelf.create(name: 'Shelf 1', owner:)
      shelf2 = Shelf.create(name: 'Shelf 2', owner:)
      format = BookFormat.create(name: 'default')
      book1 = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:,
        shelf: shelf1
      )
      book2 = Book.create(
        title: 'The Lord of the Rings',
        book_format: format,
        owner:,
        shelf: shelf1
      )
      book3 = Book.create(
        title: 'The Silmarillion',
        book_format: format,
        owner:,
        shelf: shelf2
      )
      expect(Book.shelf_books(shelf1)).to include(book1, book2)
      expect(Book.shelf_books(shelf1)).not_to include(book3)
    end

    it 'displays books without a shelf' do
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      format = BookFormat.create(name: 'default')
      shelf = Shelf.create(name: 'Shelf 1', owner:)
      book1 = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:,
      )
      book2 = Book.create(
        title: 'The Lord of the Rings',
        book_format: format,
        owner:,
      )
      book3 = Book.create(
        title: 'The Silmarillion',
        book_format: format,
        owner:,
        shelf:
      )
      expect(Book.no_shelf).to include(book1, book2)
      expect(Book.no_shelf).not_to include(book3)
    end

    it 'displays books with a certain letter' do
      owner = Owner.create(email: 'john@doe.com', password: 'password')
      format = BookFormat.create(name: 'default')
      book1 = Book.create(
        title: 'The Hobbit',
        book_format: format,
        owner:
      )
      book2 = Book.create(
        title: 'The Hound of Baskerville',
        book_format: format,
        owner:,
      )
      book3 = Book.create(
        title: 'The Silmarillion',
        book_format: format,
        owner:,
      )
      expect(Book.letter('h')).to include(book1, book2)
      expect(Book.letter('h')).not_to include(book3)
    end
    # my books
    # shelf books
    # no shelf
    # letter

  end
end
# rubocop:enable Metrics/BlockLength
