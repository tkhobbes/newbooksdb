class AddRatingToBook < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :rating, :integer, default: 0
  end
end
