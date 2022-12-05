# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id             :bigint           not null, primary key
#  condition      :integer          default("not_given")
#  country        :string(255)
#  edition        :string(255)
#  identifier     :string(255)
#  isbn           :string(255)
#  original_title :string(255)
#  pages          :integer
#  rating         :integer          default("not_rated")
#  slug           :string(255)
#  sort_title     :string(255)
#  source_url     :string(255)
#  title          :string(255)      not null
#  year           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  author_id      :bigint
#  book_format_id :bigint           not null
#  owner_id       :bigint           not null
#  publisher_id   :bigint
#  shelf_id       :bigint
#
# Indexes
#
#  fk_rails_53d51ce16a                     (author_id)
#  fk_rails_5e29c313c6                     (shelf_id)
#  fk_rails_d7ae2b039e                     (publisher_id)
#  index_books_on_book_format_id           (book_format_id)
#  index_books_on_identifier               (identifier)
#  index_books_on_identifier_and_owner_id  (identifier,owner_id) UNIQUE
#  index_books_on_isbn                     (isbn)
#  index_books_on_isbn_and_owner_id        (isbn,owner_id) UNIQUE
#  index_books_on_original_title           (original_title)
#  index_books_on_owner_id                 (owner_id)
#  index_books_on_slug                     (slug) UNIQUE
#  index_books_on_title                    (title)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => authors.id)
#  fk_rails_...  (book_format_id => book_formats.id)
#  fk_rails_...  (owner_id => owners.id)
#  fk_rails_...  (publisher_id => publishers.id)
#  fk_rails_...  (shelf_id => shelves.id)
#

# rubocop:disable Metrics/BlockLength
FactoryBot.define do
  factory :hobbit, class: Book do
    title { 'The Hobbit' }
    year { 1937 }
    rating { 5 }
    condition { 4 }
    synopsis {  "<p>#{Faker::Lorem.paragraphs(number: 30).join(' ')}</p>" }
    association :book_format, factory: :hardcover
    association :owner, factory: :me
    genres { [ create(:fiction) ] }
    association :shelf, factory: :office_tk

    after(:build) do |hobbit|
      hobbit.cover.attach(
        # rubocop:disable Rails/FilePath
        io: File.open(Rails.root.join('db', 'sample', 'images', 'cover-1.jpg')),
        # rubocop:enable Rails/FilePath
        filename: 'cover.jpg',
        content_type: 'image/jpeg'
      )
    end
  end

  factory :a_prefix_book, class: Book do
    title { 'A wonderful Life of an Ant' }
    year { 1980 }
    association :book_format, factory: :softcover
    association :owner, factory: :random_user
  end

  factory :german_translation, class: Book do
    title { 'Der Herr der Ringe' }
    year { 1955}
    original_title { 'The Lord of the Rings' }
    rating { 3 }
    association :book_format, factory: :hardcover
    association :owner, factory: :random_user
  end

  factory :random_book, class: Book do
    title { Faker::Book.title }
    year { Random.rand(1920..2020) }
    rating { Random.rand(0..5) }
    condition { Random.rand(0..5) }
    association :book_format, factory: :not_defined
    association :owner, factory: :random_user
  end
end
# rubocop:enable Metrics/BlockLength
