# == Schema Information
#
# Table name: scan_queues
#
#  id         :bigint           not null, primary key
#  isbn       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ScanQueue < ApplicationRecord
end
