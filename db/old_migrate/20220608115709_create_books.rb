class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :sort_title
      t.integer :year

      t.timestamps
    end
  end
end
