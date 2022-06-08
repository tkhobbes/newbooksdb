# Book Model
# @author: tkhobbes
class Book < ApplicationRecord
  validates :title, presence: true

  before_save :create_sort_title

  private

  # Removes common leading words from the title and converts it to downcase
  def create_sort_title
    self.sort_title = self.title.gsub(/^ein |^eine |^der |^die |^das |^the |^a |^an /i, '').gsub(/'|"|!|\?|-/, '').gsub(/(?<!\w) /,'').downcase
  end
end
