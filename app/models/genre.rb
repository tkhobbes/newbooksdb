# frozen_string_literal: true

# == Schema Information
#
# Table name: genres
#
#  id          :bigint           not null, primary key
#  books_count :integer          default(0)
#  name        :string(255)      not null
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_genres_on_name  (name) UNIQUE
#  index_genres_on_slug  (slug) UNIQUE
#
class Genre < ApplicationRecord
  # each genre must have a name and can exist only once
  validates :name, presence: true, uniqueness: true
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :books
  # rubocop:enable Rails/HasAndBelongsToMany

  extend FriendlyId
  friendly_id :name, use: :slugged

  # ensure cache is updated after creation and removal of book
  after_create { Rails.cache.increment('genres-count') }
  after_destroy { Rails.cache.decrement('genres-count') }

  # scope needed for the bulk action "remove genres without books"
  scope :no_books, -> { left_joins(:books).where(books: { id: [0, nil, ''] }) }

  def increase_books_count
    self.update(books_count: self.books_count += 1)
  end

  def decrease_books_count
    self.update(books_count: self.books_count -= 1)
  end
end
