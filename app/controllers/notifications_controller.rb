# frozen_string_literal: true

# controller to display all notifications
class NotificationsController < ApplicationController
  before_action :authenticate_owner!

  # this method smells of :reek:DuplicateMethodCall
  def index
    @notifications = scoped_notifications.newest_first.unread.includes([:recipient])
    @previous_notifications = scoped_notifications.newest_first.read.includes([:recipient])
  end

  def read_all
    current_owner.profile.notifications.mark_as_read!
    redirect_to notifications_path, notice: 'Marked all as read'
  end

  # this method smells of :reek:TooManyStatements
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
    @notifications = scoped_notifications.all
    @notifications.destroy_all
    redirect_to notifications_path,
      alert: "All #{Notification.model_name.human(count: 10)} removed",
      status: :see_other
  end

  private

  def scoped_notifications
    current_owner.profile.notifications
  end
end
