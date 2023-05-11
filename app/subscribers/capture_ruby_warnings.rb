# frozen_string_literal: true

# an extension for ruby 2.7 deprecation warnings
# from here:
# https://blog.testdouble.com/posts/2023-04-24-stop-ignoring-your-ruby-and-rails-deprecations/
module CaptureRubyWarnings
  RUBY_2_7_DEPRECATIONS = [
    'Using the last argument as keyword parameters is deprecated',
    'Passing the keyword argument as the last hash parameter is deprecated',
    'Splitting the last argument into positional and keyword parameters is deprecated',
  ]

  def warn(message)
    if RUBY_2_7_DEPRECATIONS.any? { |warning| message.include?(warning) }
      ActiveSupport::Deprecation.warn(message)
    else
      super
    end
  end
end

Warning.extend(CaptureRubyWarnings)
