# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  activation_digest :string(255)
#  admin             :boolean
#  books_count       :integer
#  email             :string(255)
#  name              :string(255)
#  password_digest   :string(255)
#  remember_digest   :string(255)
#  reset_digest      :string(255)
#  reset_sent_at     :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  validates :name, presence: true
  # this is from Michael Hartl's Rails Tutorial
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  has_one_attached :avatar

  # application relations
  has_many :books, dependent: :destroy
  has_many :shelves, dependent: :destroy

  # users are OWNING tags, but tags aren't used to TAG users
  has_many :tags, dependent: :destroy

  # scopes
  # all users but the one with a specific ID
  scope :all_but, ->(user) { where.not(id: user) }

  # ensure cache is updated after creation and removal of user
  after_create { Rails.cache.increment('users-count') }
  after_destroy { Rails.cache.decrement('users-count') }

  # returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # we need an attribute 'remember_token', 'activation_token' and 'reset_token' to store the token
  # this line smells of :reek:Attribute
  attr_accessor :remember_token, :activation_token, :reset_token

  # convert e-mail address to lowercase before saving
  before_save :downcase_email
  # automatically create an activation digest
  before_create :create_activation_digest

  # returns a random token.
  # this is a CLASS method
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(:remember_digest, User.digest(remember_token))
    # rubocop:enable Rails/SkipsModelValidations
    remember_digest
  end

  # forgets a user
  def forget
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(:remember_digest, nil)
    # rubocop:enable Rails/SkipsModelValidations
  end

  # returns true if the given token matches the digest
  # this method smells of :reek:NilCheck
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # returns a session token to prevent session hijacking
  # we reuse the remember digest for convenience
  def session_token
    remember_digest || remember
  end

  # activates an account
  def activate
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
    # rubocop:enable Rails/SkipsModelValidations
  end

  # sends an activation e-mail
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # sets password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    # rubocop:disable Rails/SkipsModelValidations
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
    # rubocop:enable Rails/SkipsModelValidations
  end

  # sends password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # returns true if a password reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  # convert email to all lowercase
  def downcase_email
    self.email = email.downcase
  end

  # creates and assignes the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
