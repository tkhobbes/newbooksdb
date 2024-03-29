# frozen_string_literal: true

# == Schema Information
#
# Table name: authors
#
#  id           :bigint           not null, primary key
#  books_count  :integer          default(0)
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
#  index_authors_on_display_name              (display_name)
#  index_authors_on_first_name_and_last_name  (first_name,last_name) UNIQUE
#  index_authors_on_slug                      (slug) UNIQUE
#  index_authors_on_sort_name                 (sort_name)
#
FactoryBot.define do
  factory :author do
    first_name { 'John' }
    last_name { 'Doe' }
  end
end
