class AddCountryToBook < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :country, :string
  end
end
