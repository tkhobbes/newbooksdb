# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'IsbnSearch' do
  describe 'authentication' do
    let(:profile) { create(:profile) }

    context 'must log in' do
      it 'cannot create a book without being logged in' do
        post isbn_create_create_path, params: {
          identifier: 'Ts_gmPmzxtUC'
        }
        expect(Book.count).to eq 0
      end

      it 'can create a book if logged in' do
        # we need a fallback format to create a book
        create(:fallback_format)
        sign_in profile.owner
        post isbn_create_create_path, params: {
          identifier: 'Ts_gmPmzxtUC'
        }
        expect(Book.count).to eq 1
      end
    end
  end
end
