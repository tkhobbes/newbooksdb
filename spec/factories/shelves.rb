# == Schema Information
#
# Table name: shelves
#
#  id          :bigint           not null, primary key
#  books_count :integer
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_shelves_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :office_tk, class: Shelf do
    name { 'Office tk' }
    association :user, factory: :me
  end

  factory :randomshelf, class: Shelf do
    name { Faker::Lorem.word }
    association :user, factory: :random_user
  end
end
