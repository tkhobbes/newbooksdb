# frozen_string_literal: true

# == Schema Information
#
# Table name: book_formats
#
# @!attribute id
#   @return []
# @!attribute format
#   @return [Integer]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
class BookFormat < ApplicationRecord
  validates :name, presence: true

  # relation to other models
  # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :books
  # rubocop:enable Rails/HasManyOrHasOneDependent

  # ensure that all books are assigned to the book format "not specified"
  before_destroy do
    # Book.update_all(book_format_id: 1)
  end
end
