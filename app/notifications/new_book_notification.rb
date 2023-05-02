# frozen_string_literal: true

# To deliver this notification:
#
# NewBookNotification.with(post: @post).deliver_later(current_user)
# NewBookNotification.with(post: @post).deliver(current_user)

# Notification for new book
class NewBookNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database, if: :book_notifications?
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  param :book

  def message
    t('.message', book: params[:book].title)
  end

  def url
    book_path(params[:book], locale: I18n.locale)
  end

  delegate :book_notifications?, to: :recipient

end
