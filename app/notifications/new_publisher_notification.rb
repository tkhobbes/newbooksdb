# frozen_string_literal: true

# To deliver this notification:
#
# NewPublisherNotification.with(post: @post).deliver_later(current_user)
# NewPublisherNotification.with(post: @post).deliver(current_user)

# notifications for new publishers
class NewPublisherNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database, if: :publisher_notifications?
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  param :publisher

  def message
    t('notifications.new_publisher_notification.message', publisher: params[:publisher].name)
  end

  def url
    publisher_path(params[:publisher], locale: I18n.locale)
  end

  delegate :publisher_notifications?, to: :recipient

end
