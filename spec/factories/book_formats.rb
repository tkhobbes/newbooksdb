# frozen_string_literal: true

# == Schema Information
#
# Table name: book_formats
#
# @!attribute id
#   @return []
# @!attribute format
#   @return [Integer]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
FactoryBot.define do
  factory :not_defined, class: BookFormat  do
    name { 'Not defined'}
  end
  factory :hardcover, class: BookFormat do
    name { 'Hardcover' }
  end

  factory :softcover, class: BookFormat do
    name { 'Softcover' }
  end
end
