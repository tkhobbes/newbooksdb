# == Schema Information
#
# Table name: genres
#
# @!attribute id
#   @return []
# @!attribute name
#   @return [String]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
#
class Genre < ApplicationRecord
  has_and_belongs_to_many :books
end
