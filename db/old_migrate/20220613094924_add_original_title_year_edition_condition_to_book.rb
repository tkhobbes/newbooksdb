class AddOriginalTitleYearEditionConditionToBook < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :condition, :integer, default: 0
    add_column :books, :edition, :string
  end
end
