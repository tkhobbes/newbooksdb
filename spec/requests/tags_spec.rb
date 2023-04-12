# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tags' do
  let(:profile) { create(:profile) }
  let(:admin_profile) { create(:admin_profile) }

  describe 'authentication' do
    let(:tag) { create(:tag, owner: profile.owner) }
    let(:tag2) { create(:tag, name: 'Tag 2', owner: profile.owner) }
    let(:tag3) { create(:tag, name: 'Tag 3', owner: admin_profile.owner) }

    context 'must log in' do
      it 'cannot see any tags when not logged in' do
        get tags_path
        expect(response).not_to have_http_status(:success)
      end

      it 'cannot see an individual tag when not logged in' do
        get tag_path(tag)
        expect(response).not_to have_http_status(:success)
      end
    end

    context 'has logged in' do
      it 'can create a tag when logged in' do
        sign_in profile.owner
        post tags_path, params: {
          tag: {
            name: 'test',
            owner: profile.owner
          }
        }
        expect(Tag.where(name: 'test').count).to eq(1)
      end

      it 'cannot create a tag unless logged in' do
        post tags_path, params: {
          tag: {
            name: 'invalid test',
            owner: profile.owner
          }
        }
        expect(Tag.where(name: 'invalid test')).to be_empty
      end

      it 'can update a tag when logged in' do
        sign_in profile.owner
        patch tag_path(tag), params: {
          tag: {
            name: 'updated'
          }
        }
        expect(tag.reload.name).to eq('updated')
      end

      it 'cannot update a tag when not logged in' do
        patch tag_path(tag2), params: {
          tag: {
            name: 'updated'
          }
        }
        expect(tag2.reload.name).to eq('Tag 2')
      end

      it 'can destroy a tag when logged in' do
        sign_in profile.owner
        delete tag_path(tag)
        expect(Tag.where(id: tag.id)).to be_empty
      end

      it 'cannot destroy a tag when not logged in' do
        delete tag_path(tag2)
        expect(Tag.where(id: tag2.id).count).to eq(1)
      end
    end
  end

  describe 'authorization' do
    let(:tag) { create(:tag, owner: profile.owner) }
    let(:tag2) { create(:tag, name: 'Tag 2', owner: profile.owner) }
    let(:tag3) { create(:tag, name: 'Tag 3', owner: admin_profile.owner) }

    context 'own tags only' do
      it 'cannot see a tag from another user' do
        sign_in profile.owner
        get tag_path(tag3)
        expect(response).not_to have_http_status(:success)
      end

      it 'cannot edit a tag from another user' do
        sign_in profile.owner
        patch tag_path(tag3), params: {
          tag: {
            name: 'updated'
          }
        }
        expect(tag3.reload.name).to eq('Tag 3')
      end

      it 'cannot destroy a tag from another user' do
        sign_in profile.owner
        delete tag_path(tag3)
        expect(Tag.where(id: tag3.id).count).to eq(1)
      end
    end

    context 'is admin' do
      it 'can edit any tag' do
        sign_in admin_profile.owner
        patch tag_path(tag), params: {
          tag: {
            name: 'admin update'
          }
        }
        expect(tag.reload.name).to eq('admin update')
      end

      it 'can destroy any tag' do
        sign_in admin_profile.owner
        delete tag_path(tag2)
        expect(Tag.where(id: tag2.id)).to be_empty
      end
    end
  end

end
