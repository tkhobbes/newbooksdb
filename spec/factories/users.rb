# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
# @!attribute id
#   @return []
# @!attribute email
#   @return [String]
# @!attribute name
#   @return [String]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :me, class: User do
    name { 'tkhobbes' }
    email { 'tkhobbes@gmail.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :random_user, class: User do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
