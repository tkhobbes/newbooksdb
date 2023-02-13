class AddUniquenessToPublishers < ActiveRecord::Migration[7.0]
  def change
    add_index :publishers, :name, unique: true
  end
end
