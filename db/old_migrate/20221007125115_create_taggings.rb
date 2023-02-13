class CreateTaggings < ActiveRecord::Migration[7.0]
  def change
    create_table :taggings do |t|
      t.integer :tag_id, null: false
      t.string :taggable_type
      t.integer :taggable_id
      t.timestamps
    end
    add_index :taggings, :tag_id
  end
end
