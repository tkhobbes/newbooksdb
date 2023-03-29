# frozen_string_literal: true

FactoryBot.define do
  factory :book_format do
    name { 'default' }
  end

  factory :fallback_format, class: 'BookFormat' do
    name { 'fallback' }
    fallback { true }
  end
end
