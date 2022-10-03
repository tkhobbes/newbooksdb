class AddIndexToBookUserId < ActiveRecord::Migration[7.0]
  def change
    add_index :books, [:title, :user_id], unique: true
  end
end
