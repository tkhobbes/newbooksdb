# frozen_string_literal: true

# == Schema Information
#
# Table name: publishers
#
#  id          :bigint           not null, primary key
#  books_count :integer          default(0)
#  location    :string(255)
#  name        :string(255)      not null
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_publishers_on_name  (name) UNIQUE
#  index_publishers_on_slug  (slug) UNIQUE
#
FactoryBot.define do
  factory :publisher do
    name { 'MyString' }
    location { 'MyString' }
    slug { 'MyString' }
  end
end
