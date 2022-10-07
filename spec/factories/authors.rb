# frozen_string_literal: true

# == Schema Information
#
# Table name: authors
#
#  id           :bigint           not null, primary key
#  books_count  :integer
#  born         :integer
#  died         :integer
#  display_name :string(255)
#  first_name   :string(255)
#  gender       :string(255)
#  last_name    :string(255)
#  rating       :integer          default("not_rated")
#  slug         :string(255)
#  sort_name    :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_authors_on_first_name_and_last_name  (first_name,last_name) UNIQUE
#  index_authors_on_slug                      (slug) UNIQUE
#
FactoryBot.define do
  factory :author do
    first_name { 'MyString' }
    last_name { 'MyString' }
    sort_name { 'MyString' }
    display_name { 'MyString' }
    born { 1 }
    died { 1 }
    gender { 'MyString' }
    rating { 1 }
    slug { 'MyString' }
    books_count { 1 }
  end
end
