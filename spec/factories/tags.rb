# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    name { 'red' }
    owner { FactoryBot.create(:profile).owner }
  end

  factory :tag2, class: 'Tag' do
    name { 'blue' }
    owner { FactoryBot.create(:admin_profile).owner }
  end
end
