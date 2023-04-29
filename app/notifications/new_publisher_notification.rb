# To deliver this notification:
#
# NewPublisherNotification.with(post: @post).deliver_later(current_user)
# NewPublisherNotification.with(post: @post).deliver(current_user)

class NewPublisherNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  param :publisher

  def message
    #t(".message")
    "New book #{params[:publisher].name} added to database"
  end

  def url
    publisher_path(params[:publisher], locale: I18n.locale)
  end
end
