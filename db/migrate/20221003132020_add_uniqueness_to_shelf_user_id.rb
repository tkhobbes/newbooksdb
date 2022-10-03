class AddUniquenessToShelfUserId < ActiveRecord::Migration[7.0]
  def change
    add_index :shelves, [:name, :user_id], unique: true
  end
end
