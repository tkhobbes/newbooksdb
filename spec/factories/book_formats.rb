# frozen_string_literal: true

# == Schema Information
#
# Table name: book_formats
#
#  id          :bigint           not null, primary key
#  books_count :integer
#  fallback    :boolean          default(FALSE)
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :not_defined, class: BookFormat  do
    name { 'Not defined'}
    fallback { true }
  end
  factory :hardcover, class: BookFormat do
    name { 'Hardcover' }
  end

  factory :softcover, class: BookFormat do
    name { 'Softcover' }
  end
end
