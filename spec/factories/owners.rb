# frozen_string_literal: true

FactoryBot.define do
  factory :owner do
    email { 'john@doe.com' }
    password { 'password'}
  end
end
