class AddNotificationsToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :book_notifications, :boolean, default: false
    add_column :profiles, :author_notifications, :boolean, default: false
    add_column :profiles, :genre_notifications, :boolean, default: false
    add_column :profiles, :publisher_notifications, :boolean, default: false
    add_column :profiles, :job_notifications, :boolean, default: true
  end
end
