# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id             :bigint           not null, primary key
#  condition      :integer          default("not_given")
#  edition        :string(255)
#  original_title :string(255)
#  rating         :integer          default("not_rated")
#  slug           :string(255)
#  sort_title     :string(255)
#  title          :string(255)      not null
#  year           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  book_format_id :bigint           not null
#  shelf_id       :integer
#  user_id        :bigint           not null
#
# Indexes
#
#  index_books_on_book_format_id  (book_format_id)
#  index_books_on_slug            (slug) UNIQUE
#  index_books_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_format_id => book_formats.id)
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
    association :user, factory: :me
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
    association :user, factory: :random_user
  end

  factory :german_translation, class: Book do
    title { 'Der Herr der Ringe' }
    year { 1955}
    original_title { 'The Lord of the Rings' }
    rating { 3 }
    association :book_format, factory: :hardcover
    association :user, factory: :random_user
  end

  factory :random_book, class: Book do
    title { Faker::Book.title }
    year { Random.rand(1920..2020) }
    rating { Random.rand(0..5) }
    condition { Random.rand(0..5) }
    association :book_format, factory: :not_defined
    association :user, factory: :random_user
  end
end
# rubocop:enable Metrics/BlockLength
