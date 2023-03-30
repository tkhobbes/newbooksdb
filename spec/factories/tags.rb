# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint           not null
#
# Indexes
#
#  index_tags_on_name               (name)
#  index_tags_on_name_and_owner_id  (name,owner_id) UNIQUE
#  index_tags_on_owner_id           (owner_id)
#  index_tags_on_slug               (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => owners.id)
#
FactoryBot.define do
  factory :tag do
    name { 'red' }
    owner { FactoryBot.create(:profile).owner }
  end

  factory :tag2, class: 'Tag' do
    name { 'blue' }
    owner { FactoryBot.create(:admin_profile).owner }
  end
end
