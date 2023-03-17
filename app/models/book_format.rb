# frozen_string_literal: true

# == Schema Information
#
# Table name: book_formats
#
#  id          :bigint           not null, primary key
#  books_count :integer          default(0)
#  fallback    :boolean          default(FALSE)
#  name        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_book_formats_on_name  (name) UNIQUE
#
class BookFormat < ApplicationRecord
  # each format can exist only once and must have a name
  validates :name, presence: true, uniqueness: true

  # call method to ensure that we assign books to a fallback format if their format is destroyed
  before_destroy :destroy_fallback

  # relation to other models
  # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :books
  # rubocop:enable Rails/HasManyOrHasOneDependent

  private
  # ensure that all books are assigned to the book format "not specified"
  def destroy_fallback
    if fallback?
      errors.add(:base, :undestroyable)
      throw :abort
    else
      format_fallback = BookFormat.find_by(fallback: true)
      Book.where(book_format_id: id).update(book_format_id: format_fallback.id)
    end
  end

end
