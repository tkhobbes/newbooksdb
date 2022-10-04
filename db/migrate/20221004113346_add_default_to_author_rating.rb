class AddDefaultToAuthorRating < ActiveRecord::Migration[7.0]
  def change
    change_column :authors, :rating, :integer, default: 0
  end
end
