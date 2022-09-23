# frozen_string_literal: true

# == Schema Information
#
# Table name: genres
#
# @!attribute id
#   @return []
# @!attribute name
#   @return [String]
# @!attribute slug
#   @return [String]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
# Indexes
#
#  index_genres_on_slug  (slug) UNIQUE
#
class Genre < ApplicationRecord
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :books
  # rubocop:enable Rails/HasAndBelongsToMany

  extend FriendlyId
  friendly_id :name, use: :slugged

  # scope needed for the bulk action "remove genres without books"
  scope :no_books, -> { left_joins(:books).where(books: { id: [0, nil, ''] }) }
end
