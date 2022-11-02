# frozen_string_literal: true

# == Schema Information
#
# Table name: shelves
#
#  id          :bigint           not null, primary key
#  books_count :integer
#  name        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :bigint           not null
#
# Indexes
#
#  index_shelves_on_name_and_owner_id  (name,owner_id) UNIQUE
#  index_shelves_on_owner_id           (owner_id)
#
class Shelf < ApplicationRecord
  # each shelf must have a name (but not necessarily unique, as different owners can have shelfs with the same name)
  validates :name, presence: true, uniqueness: { scope: :owner_id }

  belongs_to :owner
  has_many :books, dependent: :nullify

  # ensure cache is updated after creation and removal of shelf
  after_create { Rails.cache.increment('shelves-count') }
  after_destroy { Rails.cache.decrement('shelves-count') }

  # scope needed for the bulk action "remove genres without books"
  scope :no_books, -> { left_joins(:books).where(books: { id: [0, nil, ''] }) }
end
