# frozen_string_literal: true

# == Schema Information
#
# Table name: authors
#
#  id           :bigint           not null, primary key
#  books_count  :integer
#  born         :integer
#  died         :integer
#  display_name :string(255)
#  first_name   :string(255)
#  gender       :string(255)
#  last_name    :string(255)
#  rating       :integer          default("not_rated")
#  slug         :string(255)
#  sort_name    :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_authors_on_first_name_and_last_name  (first_name,last_name) UNIQUE
#  index_authors_on_slug                      (slug) UNIQUE
#
class Author < ApplicationRecord
  # must have a unique combination of first name and last name
  validates :first_name, uniqueness: { scope: :last_name }

  has_one_attached :portrait

  # database relations
  has_many :books, dependent: :nullify

  # authors can be rated
  include Rateable

  # create all names that are required
  after_create :create_sort_name
  before_save :create_sort_name
  before_save :create_display_name

  # use sort name for friendly_id
  extend FriendlyId
  friendly_id :sort_name, use: :slugged

  # ensure cache is updated after creation and removal of book
  after_create { Rails.cache.increment('genres-count') }
  after_destroy { Rails.cache.decrement('genres-count') }

  scope :no_books, -> { left_joins(:books).where(books: { id: [0, nil, ''] }) }
  scope :dead, -> { where("died > 0" ) }
  scope :alive, -> { where(died: [nil, '']) }

  # some easy helper methods
  def dead?
    died.present?
  end

  def age
    dead? ? died - born : Time.now.year - born
  end

  private

  def create_sort_name
    self.sort_name = "#{last_name}, #{first_name}"
  end

  def create_display_name
    self.display_name = "#{first_name} #{last_name}"
  end

  def should_generate_new_friendly_id?
    first_name_changed? || last_name_changed? || super
  end
end
