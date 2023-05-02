# frozen_string_literal: true

# To deliver this notification:
#
# NewGenreNotification.with(post: @post).deliver_later(current_user)
# NewGenreNotification.with(post: @post).deliver(current_user)

# notifications for new genres
class NewGenreNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database, if: :genre_notifications?
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  param :genre

  def message
    t('notifications.new_genre_notification.message', genre: params[:genre].name)
  end

  def url
    genre_path(params[:genre], locale: I18n.locale)
  end

  delegate :genre_notifications?, to: :recipient

end
