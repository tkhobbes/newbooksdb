# == Schema Information
#
# Table name: genres
#
# @!attribute id
#   @return []
# @!attribute books_count
#   @return [Integer]
# @!attribute name
#   @return [String]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
FactoryBot.define do
  factory :fiction, class: Genre do
    name { 'Fiction' }
  end

  factory :adventure, class: Genre do
    name { 'Adventure' }
  end

  factory :scifi, class: Genre do
    name { 'Science Fiction' }
  end
end
