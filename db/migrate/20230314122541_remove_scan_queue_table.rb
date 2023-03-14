class RemoveScanQueueTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :scan_queues
  end
end
