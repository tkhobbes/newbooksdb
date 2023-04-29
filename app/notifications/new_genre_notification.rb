# To deliver this notification:
#
# NewGenreNotification.with(post: @post).deliver_later(current_user)
# NewGenreNotification.with(post: @post).deliver(current_user)

class NewGenreNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  param :genre

  def message
    #t(".message")
    "New genre #{params[:genre].name} added to database"
  end

  def url
    genre_path(params[:genre], locale: I18n.locale)
  end
end
