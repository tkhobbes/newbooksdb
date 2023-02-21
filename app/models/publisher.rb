# frozen_string_literal: true

# == Schema Information
#
# Table name: publishers
#
#  id          :bigint           not null, primary key
#  books_count :integer          default(0)
#  location    :string(255)
#  name        :string(255)      not null
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_publishers_on_name  (name) UNIQUE
#  index_publishers_on_slug  (slug) UNIQUE
#
class Publisher < ApplicationRecord
  # each publisher must have a name and can exist only once
  validates :name, presence: true, uniqueness: true

  has_many :books, dependent: :nullify

  include Presentable

  # friendly ID uses slug
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # define possibilities for slug: name or name-location
  def slug_candidates
    [
      :name,
      [:name, :location]
    ]
  end

  # ensure cache is updated after creation and removal of book
  after_create { Rails.cache.increment('publishers-count') }
  after_destroy { Rails.cache.decrement('publishers-count') }

  # scopes to delete publishers that have no books
  scope :no_books, -> { left_joins(:books).where(books: { id: [0, nil, ''] }) }
  # scope to have navigation working
  scope :letter, -> (letter) { where('LEFT(name,1) LIKE ?', "#{letter}%") }

end
