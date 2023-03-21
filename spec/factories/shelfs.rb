# frozen_string_literal: true

FactoryBot.define do
  factory :shelf do
    name { 'Office' }
    owner
  end
end
