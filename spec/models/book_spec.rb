# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book do
  describe 'Validations' do
    let(:format) { create(:book_format) }
    let(:owner) { create(:owner) }

    context 'when a book is created' do
      it 'allows only one book with the same identifier by owner' do
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
        second_owner = create(:owner, email: 'jane@doe.com')
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
        second_owner = create(:owner, email: 'jane@doe.com')
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
        book = Book.new(title: 'The Hobbit', owner:)
        book.valid?
        expect(book.errors[:book_format_id]).to include("can't be blank")
      end

      it 'is it not valid if the title is missing' do
        book = Book.new(book_format: format, owner:)
        book.valid?
        expect(book.errors[:title]).to include("can't be blank")
      end

      it 'is not valid if the owner is missing' do
        book = Book.new(title: 'The Hobbit', book_format: format)
        book.valid?
        expect(book.errors[:owner]).to include('must exist')
      end

      it 'is valid if a title, a owner and a format are given' do
        book = Book.new(
          title: 'The Hobbit',
          book_format: format,
          owner:
        )
        expect(book).to be_valid
      end

      it 'removes prefixes from the sort title' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner:,
        )
        expect(book.sort_title).to eq('hobbit')
      end

      it 'creates a slug from the title' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner:,
        )
        expect(book.slug).to eq('the-hobbit')
      end
    end

    context 'when a book is changed' do
      it 'updates the slug when the title is changed' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner:,
        )
        book.update!(title: 'Der kleine Hobbit')
        expect(book.reload.slug).to eq('der-kleine-hobbit')
      end
    end
  end

  describe 'Ratings and Conditions' do
    let(:format) { create(:book_format) }
    let(:owner) { create(:owner) }

    context 'Rating methods' do
      it 'has a default rating of not_rated' do
        book = Book.new(
          title: 'The Hobbit',
          book_format: format,
          owner:
        )
        expect(book.rating).to eq('not_rated')
      end

      it 'responds to rated? with true if book is rated' do
        book = Book.new(
          title: 'The Hobbit',
          book_format: format,
          owner:,
          rating: 5
        )
        expect(book.rated?).to be(true)
      end

      it 'defaults to rated? false if book is not rated' do
        book = Book.new(
          title: 'The Hobbit',
          book_format: format,
          owner:,
        )
        expect(book.rated?).to be(false)
      end
    end # Context Ratings

    context 'condition methods' do
      it 'has a default condition of not_given' do
        book = Book.new(
          title: 'The Hobbit',
          book_format: format,
          owner:
        )
        expect(book.condition).to eq('not_given')
      end
    end # Context conditions
  end # Describe Ratings and Conditions


  describe 'identifiers, ISBNs and IDs are created properly' do
    let(:format) { create(:book_format) }
    let(:owner) { create(:owner) }

    context 'identifiers' do
      it 'checks the identifier and does not change if it existing' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner:,
          identifier: 'abc123-4'
        )
        expect(book.identifier).to eq('abc123-4')
      end

      it 'checks the identifier and creates one if not existing' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner:
        )
        expect(book.identifier[0]).to eq(owner.id.to_s[0])
      end
    end # Context identifiers

    context 'ISBNs' do
      it 'checks the ISBN and does not change if it is existing' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner:,
          isbn: '9783161484100'
        )
        expect(book.isbn).to eq('9783161484100')
      end

      it 'checks the ISBN and creates one if it is not existing' do
        book = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner:
        )
        expect(book.isbn[0..6]).to eq("dummy-#{owner.id.to_s[0]}")
      end
    end # Context ISBNs
  end # Describe identifiers, ISBNs and IDs are created properly

  describe 'scopes display the right books' do
    let(:format) { create(:book_format) }
    let(:owner) { create(:owner) }

    context 'Owner scopes' do
      it "shows a owner's books as 'my books'" do
        owner2 = Owner.create(email: 'jane@doe.com', password: 'password')
        book1 = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner:
        )
        book2 = Book.create(
          title: 'The Lord of the Rings',
          book_format: format,
          owner:
        )
        book3 = Book.create(
          title: 'The Silmarillion',
          book_format: format,
          owner: owner2
        )
        expect(Book.my_books(owner)).to include(book1, book2)
        expect(Book.my_books(owner)).not_to include(book3)
      end
    end # Context Owner scopes

    context 'shelf scopes' do
      it 'shows books of a certain shelf' do
        shelf1 = create(:shelf, owner:)
        shelf2 = create(:shelf, name: 'Shelf 2', owner:)
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
        shelf = create(:shelf, owner:)
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
    end # Context shelf scopes

    context 'letter scopes' do
      it 'displays books with a certain letter' do
        book1 = Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner:
        )
        book2 = Book.create(
          title: 'The Hound of Baskerville',
          book_format: format,
          owner:
        )
        book3 = Book.create(
          title: 'The Silmarillion',
          book_format: format,
          owner:
        )
        expect(Book.letter('h')).to include(book1, book2)
        expect(Book.letter('h')).not_to include(book3)
      end
    end # Context letter scopes
  end # Describe scopes display the right books
end
