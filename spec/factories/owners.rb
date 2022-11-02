# == Schema Information
#
# Table name: owners
#
#  id                     :bigint           not null, primary key
#  books_count            :integer
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
  factory :me, class: Owner do
    email { 'tkhobbes@gmail.com' }
    encrypted_password { Devise::Encryptor.digest(Owner, 'password') }
  end

  factory :random_user, class: Owner do
    email { Faker::Internet.email }
    password { Devise::Encryptor.digest(Owner, 'password') }
  end
end
