# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_tags_on_name_and_user_id  (name,user_id) UNIQUE
#  index_tags_on_slug              (slug) UNIQUE
#  index_tags_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Tag < ApplicationRecord
  # each tag must have a name
  validates :name, presence: true, uniqueness: { scope: :user_id }

  extend FriendlyId
  friendly_id :name_user, use: :slugged

  # tag are OWNED by a user but are not used to TAG users
  belongs_to :user


  has_many :taggings
  has_many :books, through: :taggings, :source => 'taggable', :source_type => 'Book'
  has_many :authors, through: :taggings, :source => 'taggable', :source_type => 'Author'

  # scope needed for the bulk action "remove genres without books"
  scope :no_taggings, -> { left_joins(:taggings).where(taggings: { id: [0, nil, ''] }) }

  private

  def name_user
    "#{name}-#{user.name}"
  end
end
