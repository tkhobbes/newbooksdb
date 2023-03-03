class CreateScanQueues < ActiveRecord::Migration[7.0]
  def change
    create_table :scan_queues do |t|
      t.string :isbn

      t.timestamps
    end
  end
end
