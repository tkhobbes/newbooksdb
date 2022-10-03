# frozen_string_literal: true

# == Schema Information
#
# Table name: book_formats
#
#  id          :bigint           not null, primary key
#  books_count :integer
#  fallback    :boolean          default(FALSE)
#  name        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_book_formats_on_name  (name) UNIQUE
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
