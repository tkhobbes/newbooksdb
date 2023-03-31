# frozen_string_literal: true

# module contains method to define the correct CSS classes for flash messages
module FlashHelper
  # rubocop:disable Metrics/MethodLength
  # this method smells of :reek:ControlParameter
  def flash_class(flash_key)
    case flash_key
    when :error
      'message-flash-error'
    when :info
      'message-flash-info'
    when :success
      'message-flash-success'
    when :alert
      'message-flash-alert'
    else
      'message-flash-notice'
    end
  end
  # rubocop:enable Metrics/MethodLength
end
