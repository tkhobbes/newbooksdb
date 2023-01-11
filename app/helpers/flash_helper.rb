# frozen_string_literal: true

module FlashHelper
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
end
