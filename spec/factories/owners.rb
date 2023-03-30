# frozen_string_literal: true

# == Schema Information
#
# Table name: owners
#
#  id                     :bigint           not null, primary key
#  books_count            :integer          default(0)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_owners_on_email                 (email) UNIQUE
#  index_owners_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :owner do
    email { 'john@doe.com' }
    password { 'password'}
  end

  factory :jimbeam, class: 'Owner' do
    email { 'jim@beam.com' }
    password { 'password' }
  end
end
