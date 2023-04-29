# frozen_string_literal: true

# controller to display all notifications
class NotificationsController < ApplicationController
  before_action :authenticate_owner!

  def index
    @notifications = current_owner.profile.notifications.newest_first.unread
    @previous_notifications = current_owner.profile.notifications.newest_first.read
  end

  def read_all
    current_owner.profile.notifications.mark_as_read!
    redirect_to notifications_path, notice: 'Marked all as read'
  end
end
