class AddIndicesToAuthors < ActiveRecord::Migration[7.0]
  def change
    add_index :authors, :display_name
    add_index :authors, :sort_name
  end
end
