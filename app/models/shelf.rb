# frozen_string_literal: true

# == Schema Information
#
# Table name: shelves
#
#  id          :bigint           not null, primary key
#  books_count :integer
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_shelves_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Shelf < ApplicationRecord
  belongs_to :user
  has_many :books, dependent: :nullify

  # ensure cache is updated after creation and removal of shelf
  after_create { Rails.cache.increment('shelves-count') }
  after_destroy { Rails.cache.decrement('shelves-count') }

  # scope needed for the bulk action "remove genres without books"
  scope :no_books, -> { left_joins(:books).where(books: { id: [0, nil, ''] }) }
end
