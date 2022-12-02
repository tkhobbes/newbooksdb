class AddIndicesToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_index :profiles, :name
  end
end
