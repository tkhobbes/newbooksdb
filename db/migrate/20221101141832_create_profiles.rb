class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.references :owner, null: false, foreign_key: true
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
