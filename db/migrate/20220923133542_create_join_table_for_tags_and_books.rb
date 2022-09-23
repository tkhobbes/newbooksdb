class CreateJoinTableForTagsAndBooks < ActiveRecord::Migration[7.0]
  def change
      create_table :books_tags do |t|
      t.references :book, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
    end
  end
end
