# To deliver this notification:
#
# NewAuthorNotification.with(post: @post).deliver_later(current_user)
# NewAuthorNotification.with(post: @post).deliver(current_user)

class NewAuthorNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  param :author

  def message
    #t(".message")
    "New author #{params[:author].display_name} added to database"
  end

  def url
    author_path(params[:author], locale: I18n.locale)
  end
end
