class CreatePublishers < ActiveRecord::Migration[7.0]
  def change
    create_table :publishers do |t|
      t.string :name
      t.string :location
      t.string :slug

      t.timestamps
    end
    add_index :publishers, :slug, unique: true
  end
end
