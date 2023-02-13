class AddAuthorIdToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :author_id, :integer, foreign_key: true
  end
end
