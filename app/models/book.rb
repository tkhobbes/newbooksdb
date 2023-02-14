# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id             :bigint           not null, primary key
#  condition      :integer          default("not_given")
#  country        :string(255)
#  edition        :string(255)
#  identifier     :string(255)
#  isbn           :string(255)
#  original_title :string(255)
#  pages          :integer
#  rating         :integer          default("not_rated")
#  slug           :string(255)
#  sort_title     :string(255)
#  source_url     :string(255)
#  title          :string(255)      not null
#  year           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  author_id      :bigint
#  book_format_id :bigint           not null
#  owner_id       :bigint           not null
#  publisher_id   :bigint
#  shelf_id       :bigint
#
# Indexes
#
#  fk_rails_53d51ce16a                     (author_id)
#  fk_rails_5e29c313c6                     (shelf_id)
#  fk_rails_d7ae2b039e                     (publisher_id)
#  index_books_on_book_format_id           (book_format_id)
#  index_books_on_identifier               (identifier)
#  index_books_on_identifier_and_owner_id  (identifier,owner_id) UNIQUE
#  index_books_on_isbn                     (isbn)
#  index_books_on_isbn_and_owner_id        (isbn,owner_id) UNIQUE
#  index_books_on_original_title           (original_title)
#  index_books_on_owner_id                 (owner_id)
#  index_books_on_slug                     (slug) UNIQUE
#  index_books_on_title                    (title)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => authors.id)
#  fk_rails_...  (book_format_id => book_formats.id)
#  fk_rails_...  (owner_id => owners.id)
#  fk_rails_...  (publisher_id => publishers.id)
#  fk_rails_...  (shelf_id => shelves.id)
#
class Book < ApplicationRecord
  validates :identifier, uniqueness: { scope: :owner_id }
  validates :isbn, uniqueness: { scope: :owner_id }
  validates :book_format_id, presence: true
  validates :title, presence: true

  before_save :create_sort_title
  before_save :check_identifier
  before_save :check_isbn

  include SearchCop
  # search cop setup
  search_scope :search do
    attributes :title, :original_title
  end

  include Rateable

  include Presentable

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
  belongs_to :owner, counter_cache: true
  belongs_to :shelf, optional: true, counter_cache: true
  belongs_to :publisher, optional: true, counter_cache: true

  has_many :books_authors, dependent: :destroy
  has_many :authors, through: :books_authors
  accepts_nested_attributes_for :authors

  has_many :books_genres, dependent: :destroy
  has_many :genres, through: :books_genres

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  # a scope for my books
  scope :my_books, -> (uid) { where(owner_id: uid) }
  scope :shelf_books, -> (shelf) { where(shelf_id: shelf) }
  scope :no_shelf, -> { where(shelf_id: nil) }
  scope :letter, -> (letter) { where('LEFT(sort_title,1) LIKE ?', "#{letter}%") }

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

  # checks whether a source ID is available - if not, create a dummy one

  def check_identifier
    self.identifier = "#{owner_id}-#{create_id}" if identifier.blank?
  end

  def check_isbn
    self.isbn = "dummy-#{owner_id}-#{create_id}" if isbn.blank?
  end

  # this method smells of :reek:DuplicateMethodCall
  # this method smells of :reek:UtilityFunction
  def create_id
    book_id = Book.last ? Book.last.id.to_s : '0'
    Digest::UUID.uuid_v3(Digest::UUID::DNS_NAMESPACE, book_id)
  end
end
