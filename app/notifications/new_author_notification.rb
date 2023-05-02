# frozen_string_literal: true

# To deliver this notification:
#
# NewAuthorNotification.with(post: @post).deliver_later(current_user)
# NewAuthorNotification.with(post: @post).deliver(current_user)

# Notification for new author
class NewAuthorNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database, if: :author_notifications?
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  param :author

  def message
    t('.message', author: params[:author].display_name)
  end

  def url
    author_path(params[:author], locale: I18n.locale)
  end

  delegate :author_notifications?, to: :recipient

end
