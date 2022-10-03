class AddNotNullToPublishers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :publishers, :name, false
  end
end
