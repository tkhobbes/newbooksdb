class AddNotNullToGenres < ActiveRecord::Migration[7.0]
  def change
    change_column_null :genres, :name, false
  end
end
