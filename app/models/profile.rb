# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id                      :bigint           not null, primary key
#  admin                   :boolean          default(FALSE)
#  author_notifications    :boolean          default(FALSE)
#  book_notifications      :boolean          default(FALSE)
#  genre_notifications     :boolean          default(FALSE)
#  job_notifications       :boolean          default(TRUE)
#  name                    :string(255)
#  publisher_notifications :boolean          default(FALSE)
#  userlocale              :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  owner_id                :bigint           not null
#
# Indexes
#
#  index_profiles_on_name      (name)
#  index_profiles_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => owners.id)
#
class Profile < ApplicationRecord
  belongs_to :owner

  has_one_attached :avatar

  has_many :notifications, as: :recipient, dependent: :destroy

  def book_notifications?
    self[:book_notifications]
  end
end
