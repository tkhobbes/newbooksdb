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
#  owner_id   :bigint           not null
#
# Indexes
#
#  index_tags_on_owner_id  (owner_id)
#  index_tags_on_slug      (slug) UNIQUE
#
class Tag < ApplicationRecord
  # each tag must have a name
  validates :name, presence: true, uniqueness: { scope: :owner_id }

  extend FriendlyId
  friendly_id :name_owner, use: :slugged

  # tag are OWNED by a owner but are not used to TAG owners
  belongs_to :owner


  has_many :taggings, dependent: :destroy
  has_many :books, through: :taggings, source: 'taggable', source_type: 'Book'
  has_many :authors, through: :taggings, source: 'taggable', source_type: 'Author'

  # scope needed for the bulk action "remove genres without books"
  scope :no_taggings, -> { left_joins(:taggings).where(taggings: { id: [0, nil, ''] }) }

  private

  def name_owner
    "#{name}-#{owner.name}"
  end
end
