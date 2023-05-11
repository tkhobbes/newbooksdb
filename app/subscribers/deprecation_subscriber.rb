# frozen_string_literal: true

# from here:
# https://blog.testdouble.com/posts/2023-04-24-stop-ignoring-your-ruby-and-rails-deprecations/
class DeprecationSubscriber < ActiveSupport::Subscriber
  # separate class for unallowed deprecations
  class UnallowedDeprecation < StandardError
    def initialize(message)
      super("Unallowed deprecation found. Please fix it.\n#{message}")
    end
  end

  attach_to :rails

  ALLOWED_DEPRECATIONS = [
    'A message for some deprecation',
    'Another message for a different deprecation',
  ].freeze

  # rubocop:disable Metrics/AbcSize
  # this method smells of :reek:DuplicateMethodCall
  # this method smells of :reek:FeatureEnvy
  # this method smells of :reek:TooManyStatements
  def deprecation(event)
    return if ALLOWED_DEPRECATIONS.any? { |allowed| event.payload[:message].include?(allowed) }

    if Rails.env.development? || Rails.env.test?
      exception = UnallowedDeprecation.new(event.payload[:message])
      exception.set_backtrace(event.payload[:callstack].map(&:to_s))
      raise exception
    else
      Rails.logger.warn("Unallowed deprecation found\n#{event.payload[:message]}")
    end
  end
  # rubocop:enable Metrics/AbcSize
end
