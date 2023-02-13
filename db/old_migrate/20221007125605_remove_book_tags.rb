class RemoveBookTags < ActiveRecord::Migration[7.0]
  def change
    drop_table :books_tags
  end
end
