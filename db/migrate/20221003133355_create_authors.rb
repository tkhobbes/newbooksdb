class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :first_name
      t.string :last_name
      t.string :sort_name
      t.string :display_name
      t.integer :born
      t.integer :died
      t.string :gender
      t.integer :rating
      t.string :slug
      t.integer :books_count

      t.timestamps
    end
    add_index :authors, :slug, unique: true
    add_index :authors, [:first_name, :last_name], unique: true
  end
end
