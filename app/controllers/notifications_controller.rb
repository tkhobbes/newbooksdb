# frozen_string_literal: true

# controller to display all notifications
class NotificationsController < ApplicationController
  before_action :authenticate_owner!

  def index
    @notifications = current_owner.profile.notifications.newest_first.unread.includes([:recipient])
    @previous_notifications = current_owner.profile.notifications.newest_first.read.includes([:recipient])
  end

  def read_all
    current_owner.profile.notifications.mark_as_read!
    redirect_to notifications_path, notice: 'Marked all as read'
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to notifications_path,
        alert: "#{Notification.model_name.human} removed", status: :see_other
      end
    end
  end

  def delete_all
    @notifications = current_owner.profile.notifications.all
    @notifications.destroy_all
    redirect_to notifications_path,
      alert: "All #{Notification.model_name.human(count: 10)} removed",
      status: :see_other
  end
end
