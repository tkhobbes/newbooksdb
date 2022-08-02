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
    format { 'Not defined'}
  end
  factory :hardcover, class: BookFormat do
    format { 'Hardcover' }
  end

  factory :softcover, class: BookFormat do
    format { 'Softcover' }
  end
end
