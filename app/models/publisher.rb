# frozen_string_literal: true

# == Schema Information
#
# Table name: publishers
#
#  id          :bigint           not null, primary key
#  books_count :integer
#  location    :string(255)
#  name        :string(255)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_publishers_on_slug  (slug) UNIQUE
#
class Publisher < ApplicationRecord
  has_many :books

  # friendly ID uses slug
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :name,
      [:name, :location]
    ]
  end
end
