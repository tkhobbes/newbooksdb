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
FactoryBot.define do
  factory :hobbit, class: Book do
    title { 'The Hobbit' }
    year { 1937 }
    rating { 5 }
    condition { 4 }
  end

  factory :a_prefix_book, class: Book do
    title { 'A wonderful Life of an Ant' }
    year { 1980 }
  end

  factory :german_translation, class: Book do
    title { 'Der Herr der Ringe' }
    year { 1955}
    original_title { 'The Lord of the Rings' }
  end

  factory :random_book, class: Book do
    title { Faker::Book.title }
    year { Random.rand(1920..2020) }
    rating { Random.rand(0..5) }
    condition { Random.rand(0..5) }
  end
end
