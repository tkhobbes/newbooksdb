# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
# @!attribute id
#   @return []
# @!attribute condition
#   @return [Integer]
# @!attribute edition
#   @return [String]
# @!attribute original_title
#   @return [String]
# @!attribute rating
#   @return [Integer]
# @!attribute slug
#   @return [String]
# @!attribute sort_title
#   @return [String]
# @!attribute title
#   @return [String]
# @!attribute year
#   @return [Integer]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
# @!attribute book_format_id
#   @return []
# @!attribute user_id
#   @return []
#
# Indexes
#
#  index_books_on_book_format_id  (book_format_id)
#  index_books_on_slug            (slug) UNIQUE
#  index_books_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_format_id => book_formats.id)
#
class Book < ApplicationRecord
  validates :title, presence: true

  before_save :create_sort_title

  include Rateable

  enum condition: {
        like_new: 5,
        used_ok: 4,
        used: 3,
        used_bad: 2,
        damaged: 1,
        not_given: 0
  }

  has_one_attached :cover
  has_rich_text :synopsis

  # relationships to other models
  belongs_to :book_format, optional: true, counter_cache: true
  belongs_to :user, counter_cache: true

  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :genres, optional: true
  # rubocop:enable Rails/HasAndBelongsToMany

  # friendly ID uses slug
  extend FriendlyId
  friendly_id :title, use: :slugged

  # ensure cache is updated after creation and removal of book
  after_create { Rails.cache.increment('books-count') }
  after_destroy { Rails.cache.decrement('books-count') }

  private

  # Removes common leading words from the title and converts it to downcase
  # @return [String] The sort title (stored in DB)
  def create_sort_title
    self.sort_title = title.gsub(/^ein |^eine |^der |^die |^das |^the |^a |^an /i, '').gsub(/'|"|!|\?|-/, '').gsub(
/(?<!\w) /,'').downcase
  end
end
