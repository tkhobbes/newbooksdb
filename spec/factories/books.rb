# == Schema Information
#
# Table name: books
#
# @!attribute id
#   @return []
# @!attribute condition
#   @return [Integer]
# @!attribute edition
#   @return [String]
# @!attribute original_title
#   @return [String]
# @!attribute rating
#   @return [Integer]
# @!attribute slug
#   @return [String]
# @!attribute sort_title
#   @return [String]
# @!attribute title
#   @return [String]
# @!attribute year
#   @return [Integer]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
# Indexes
#
#  index_books_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :hobbit, class: Book do
    title { 'The Hobbit' }
    year { 1937 }
    rating { 5 }
    condition { 4 }

    after(:build) do |hobbit|
      hobbit.cover.attach(
        io: File.open(Rails.root.join('db', 'sample', 'images', 'cover-1.jpg')),
        filename: 'cover.jpg',
        content_type: 'image/jpeg'
      )
    end
  end

  factory :a_prefix_book, class: Book do
    title { 'A wonderful Life of an Ant' }
    year { 1980 }
  end

  factory :german_translation, class: Book do
    title { 'Der Herr der Ringe' }
    year { 1955}
    original_title { 'The Lord of the Rings' }
    rating { 3 }
  end

  factory :random_book, class: Book do
    title { Faker::Book.title }
    year { Random.rand(1920..2020) }
    rating { Random.rand(0..5) }
    condition { Random.rand(0..5) }
  end
end
