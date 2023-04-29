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
      format.html { redirect_to notifications_path, alert: "#{Notification.model_name.human} removed", status: :see_other }
    end
  end
end
