# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_tags_on_slug     (slug) UNIQUE
#  index_tags_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :name_user, use: :slugged

  # tag are OWNED by a user but are not used to TAG users
  belongs_to :user

  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :books
  # rubocop:enable Rails/HasAndBelongsToMany

  private

  def name_user
    "#{name}-#{user.name}"
  end
end
