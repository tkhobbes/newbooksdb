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

  # relation to other models
  has_many :books, dependent: :restrict_with_exception
end
