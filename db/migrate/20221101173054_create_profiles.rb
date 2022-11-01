class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.boolean :admin, default: false
      t.references :owner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
