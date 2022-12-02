# frozen_string_literal: true

# == Schema Information
#
# Table name: shelves
#
#  id          :bigint           not null, primary key
#  books_count :integer
#  name        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :bigint           not null
#
# Indexes
#
#  index_shelves_on_name               (name)
#  index_shelves_on_name_and_owner_id  (name,owner_id) UNIQUE
#  index_shelves_on_owner_id           (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => owners.id)
#
FactoryBot.define do
  factory :office_tk, class: Shelf do
    name { 'Office tk' }
    association :owner, factory: :me
  end

  factory :randomshelf, class: Shelf do
    name { Faker::Lorem.word }
    association :owner, factory: :random_user
  end
end
