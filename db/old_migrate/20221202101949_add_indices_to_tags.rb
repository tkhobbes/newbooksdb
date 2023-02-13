class AddIndicesToTags < ActiveRecord::Migration[7.0]
  def change
    add_index :tags, :name
    add_foreign_key :tags, :owners
  end
end
