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
#  user_id     :bigint           not null
#
# Indexes
#
#  index_shelves_on_name_and_user_id  (name,user_id) UNIQUE
#  index_shelves_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Shelf < ApplicationRecord
  # each shelf must have a name (but not necessarily unique, as different users can have shelfs with the same name)
  validates :name, presence: true, uniqueness: { scope: :user_id }

  belongs_to :user
  has_many :books, dependent: :nullify

  # ensure cache is updated after creation and removal of shelf
  after_create { Rails.cache.increment('shelves-count') }
  after_destroy { Rails.cache.decrement('shelves-count') }

  # scope needed for the bulk action "remove genres without books"
  scope :no_books, -> { left_joins(:books).where(books: { id: [0, nil, ''] }) }
end
