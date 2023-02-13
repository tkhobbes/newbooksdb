class CreateBookFormats < ActiveRecord::Migration[7.0]
  def change
    create_table :book_formats do |t|
      t.integer :format

      t.timestamps
    end
  end
end
