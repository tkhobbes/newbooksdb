class AddUniquenessToGenreName < ActiveRecord::Migration[7.0]
  def change
    add_index :genres, :name, unique: true
  end
end
