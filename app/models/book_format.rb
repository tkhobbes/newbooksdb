# frozen_string_literal: true

# == Schema Information
#
# Table name: book_formats
#
# @!attribute id
#   @return []
# @!attribute name
#   @return [string]
# @!attribute fallback
#  @return [boolean]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
class BookFormat < ApplicationRecord
  validates :name, presence: true

  # call method to ensure that we assign books to a fallback format if their format is destroyed
  before_destroy :destroy_fallback

  # relation to other models
  # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :books
  # rubocop:enable Rails/HasManyOrHasOneDependent

  private
  # ensure that all books are assigned to the book format "not specified"
  def destroy_fallback
    if self.fallback?
      errors.add(:base, :undestroyable)
      throw :abort
    else
      format_fallback = BookFormat.find_by(fallback: true)
      Book.where(book_format_id: self.id).update(book_format_id: format_fallback.id)
    end
  end

end
