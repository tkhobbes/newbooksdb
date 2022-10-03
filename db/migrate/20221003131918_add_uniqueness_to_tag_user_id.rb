class AddUniquenessToTagUserId < ActiveRecord::Migration[7.0]
  def change
    add_index :tags, [:name, :user_id], unique: true
  end
end
