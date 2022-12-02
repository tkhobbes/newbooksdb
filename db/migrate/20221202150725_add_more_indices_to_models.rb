class AddMoreIndicesToModels < ActiveRecord::Migration[7.0]
  def change
    change_column :taggings, :tag_id, :bigint

    add_foreign_key :taggings, :tags

  end
end
