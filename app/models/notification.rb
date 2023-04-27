# == Schema Information
#
# Table name: notifications
#
#  id             :bigint           not null, primary key
#  params         :text(4294967295)
#  read_at        :datetime
#  recipient_type :string(255)      not null
#  type           :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  recipient_id   :bigint           not null
#
# Indexes
#
#  index_notifications_on_read_at    (read_at)
#  index_notifications_on_recipient  (recipient_type,recipient_id)
#
class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true
end
