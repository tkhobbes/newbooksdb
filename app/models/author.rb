# frozen_string_literal: true

# == Schema Information
#
# Table name: authors
#
#  id           :bigint           not null, primary key
#  books_count  :integer          default(0)
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
#  index_authors_on_display_name              (display_name)
#  index_authors_on_first_name_and_last_name  (first_name,last_name) UNIQUE
#  index_authors_on_slug                      (slug) UNIQUE
#  index_authors_on_sort_name                 (sort_name)
#
class Author < ApplicationRecord
  # must have a unique combination of first name and last name
  validates :first_name, uniqueness: { scope: :last_name }
  validate :at_least_first_or_last

  has_one_attached :portrait

  # database relations
  has_many :books_authors, dependent: :destroy
  has_many :books, through: :books_authors

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  include SearchCop
  # search cop setup
  search_scope :search do
    attributes :display_name, :sort_name
  end
  # authors can be rated
  include Rateable

  # create all names that are required
  before_save :create_sort_name
  before_save :create_display_name
  after_create :create_sort_name

  # use sort name for friendly_id
  extend FriendlyId
  friendly_id :display_name, use: :slugged

  # ensure cache is updated after creation and removal of book
  after_create { Rails.cache.increment('authors-count') }
  after_destroy { Rails.cache.decrement('authors-count') }

  scope :no_books, -> { left_joins(:books).where(books: { id: [0, nil, ''] }) }
  scope :dead, -> { where('died > 0') }
  scope :alive, -> { where(died: [nil, '']) }
  scope :letter, -> (letter) { where('LEFT(sort_name,1) LIKE ?', "#{letter}%") }

  # some easy helper methods
  def dead?
    died.present?
  end

  def age
    dead? ? died - born : Time.zone.now.year - born
  end

  # used for the standard unused items views
  def name
    display_name
  end

  private

  def create_sort_name
    self.sort_name = "#{last_name}, #{first_name}" if last_name.present? && first_name.present?
    self.sort_name = first_name if last_name.blank?
    self.sort_name = last_name if first_name.blank?
  end

  def create_display_name
    self.display_name = "#{first_name} #{last_name}" if last_name.present? && first_name.present?
    self.display_name = first_name if last_name.blank?
    self.display_name = last_name if first_name.blank?
  end

  def should_generate_new_friendly_id?
    first_name_changed? || last_name_changed? || super
  end

  # custom validation method

  def at_least_first_or_last
    return if first_name.present? || last_name.present?
    errors.add(:first_name, 'Need at least a first or last name')
  end

end
