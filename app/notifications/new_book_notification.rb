# To deliver this notification:
#
# NewBookNotification.with(post: @post).deliver_later(current_user)
# NewBookNotification.with(post: @post).deliver(current_user)

class NewBookNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  param :book

  def message
    #t(".message")
    "New book #{params[book].title} added to database"
  end

  def url
    book_path(params[:book])
  end
end
