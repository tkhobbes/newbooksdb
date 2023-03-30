# frozen_string_literal: true

# == Schema Information
#
# Table name: book_formats
#
#  id          :bigint           not null, primary key
#  books_count :integer          default(0)
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
  factory :book_format do
    name { 'default' }
  end

  factory :fallback_format, class: 'BookFormat' do
    name { 'fallback' }
    fallback { true }
  end
end
