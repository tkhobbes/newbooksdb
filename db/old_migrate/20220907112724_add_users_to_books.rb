class AddUsersToBooks < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :user, null: false
  end
end
