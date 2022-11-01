# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  admin      :boolean          default(FALSE)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint           not null
#
# Indexes
#
#  index_profiles_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => owners.id)
#
class Profile < ApplicationRecord
  belongs_to :owner

  has_one_attached :avatar
end
