# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    owner
    admin { false }
    name { 'JonnyD' }
  end

  factory :admin_profile, class: 'Profile' do
    association :owner, factory: :jimbeam
    admin { true }
    name { 'Admin James' }
  end
end
