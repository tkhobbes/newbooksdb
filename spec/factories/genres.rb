# frozen_string_literal: true

# == Schema Information
#
# Table name: genres
#
# @!attribute id
#   @return []
# @!attribute name
#   @return [String]
# @!attribute slug
#   @return [String]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
# Indexes
#
#  index_genres_on_slug  (slug) UNIQUE
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
