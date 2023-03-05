# == Schema Information
#
# Table name: scan_queues
#
#  id         :bigint           not null, primary key
#  isbn       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint           not null
#
# Indexes
#
#  index_scan_queues_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => owners.id)
#
class ScanQueue < ApplicationRecord
  belongs_to :owner
end
