# frozen_string_literal: true

# == Schema Information
#
# Table name: genres
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_genres_on_name  (name) UNIQUE
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
