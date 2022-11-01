# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint           not null
#
# Indexes
#
#  index_tags_on_owner_id  (owner_id)
#  index_tags_on_slug      (slug) UNIQUE
#
FactoryBot.define do
  factory :tag do
    name { 'MyString' }
    user { nil }
  end
end
