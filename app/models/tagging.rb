# frozen_string_literal: true

# == Schema Information
#
# Table name: taggings
#
#  id            :bigint           not null, primary key
#  taggable_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tag_id        :integer          not null
#  taggable_id   :integer
#
# Indexes
#
#  index_taggings_on_tag_id  (tag_id)
#
class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
end
