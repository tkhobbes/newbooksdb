# == Schema Information
#
# Table name: owners
#
#  id                     :bigint           not null, primary key
#  books_count            :integer
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_owners_on_email                 (email) UNIQUE
#  index_owners_on_reset_password_token  (reset_password_token) UNIQUE
#
class Owner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # convert e-mail address to lowercase before saving
  before_save :downcase_email

  has_one :profile, dependent: :destroy

  delegate :name, :admin , to: :profile

  # application relations
  has_many :books, dependent: :destroy
  has_many :shelves, dependent: :destroy

  # owners are OWNING tags, but tags aren't used to TAG owners
  has_many :tags, dependent: :destroy

  # scopes
  # all owners but the one with a specific ID
  scope :all_but, ->(owner) { where.not(id: owner) }

  # ensure cache is updated after creation and removal of user
  after_create { Rails.cache.increment('owners-count') }
  after_destroy { Rails.cache.decrement('owners-count') }

  def ownername
    email.split('@').first
  end

  private

  # convert email to all lowercase
  def downcase_email
    self.email = email.downcase
  end
end
