class AddIsbnPagesSourceidSourceurlToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :isbn, :string
    add_column :books, :pages, :integer
    add_column :books, :source_id, :string
    add_column :books, :source_url, :string
    add_index :books, [:isbn, :owner_id], unique: true
  end
end
