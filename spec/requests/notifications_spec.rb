# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notifications' do
  describe 'notifications are sent' do
    context 'upon creation of core models' do
      let(:format) { create(:book_format) }
      let(:profile) do
        create(:profile,
        book_notifications: true,
        author_notifications: true,
        publisher_notifications: true,
        genre_notifications: true)
      end

      it 'sends a notification when a new book is created' do
        sign_in profile.owner
        Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner: profile.owner
        )
        expect(Book.count).to eq 1
        expect(Notification.where(recipient: profile, type: 'NewBookNotification').size).to be 1
      end

      it 'sends a notification when a new author is created' do
        sign_in profile.owner
        Author.create(
          first_name: 'JRR',
          last_name: 'Tolkien'
        )
        expect(Author.count).to eq 1
        expect(Notification.where(recipient: profile, type: 'NewAuthorNotification').size).to be 1
      end

      it 'sends a notification when a new publisher is created' do
        sign_in profile.owner
        Publisher.create(
          name: 'ABC Books'
        )
        expect(Publisher.count).to eq 1
        expect(Notification.where(recipient: profile, type: 'NewPublisherNotification').size).to be 1
      end

      it 'sends a notification when a new genre is created' do
        sign_in profile.owner
        Genre.create(
          name: 'Fantasy'
        )
        expect(Genre.count).to eq 1
        expect(Notification.where(recipient: profile, type: 'NewGenreNotification').size).to be 1
      end
    end

    context 'notifications are sent only to users who subscribed' do
      let(:format) { create(:book_format) }
      let(:profile) do
        create(:profile,
        book_notifications: false,
        author_notifications: false,
        publisher_notifications: false,
        genre_notifications: false)
      end

      it 'does not send a notification when a new book is created to non-subscribers' do
        sign_in profile.owner
        Book.create(
          title: 'The Hobbit',
          book_format: format,
          owner: profile.owner
        )
        expect(Book.count).to eq 1
        expect(Notification.where(recipient: profile, type: 'NewBookNotification').size).to be 0
      end

      it 'does not send a notification when a new author is created to non-subscribers' do
        sign_in profile.owner
        Author.create(
          first_name: 'JRR',
          last_name: 'Tolkien'
        )
        expect(Author.count).to eq 1
        expect(Notification.where(recipient: profile, type: 'NewAuthorNotification').size).to be 0
      end

      it 'does not send a notification when a new publisher is created to non-subscribers' do
        sign_in profile.owner
        Publisher.create(
          name: 'ABC Books'
        )
        expect(Publisher.count).to eq 1
        expect(Notification.where(recipient: profile, type: 'NewPublisherNotification').size).to be 0
      end

      it 'does not send a notification when a new genre is created to non-subscribers' do
        sign_in profile.owner
        Genre.create(
          name: 'Fantasy'
        )
        expect(Genre.count).to eq 1
        expect(Notification.where(recipient: profile, type: 'NewGenreNotification').size).to be 0
      end
    end
  end

  describe 'notification handling' do
    let!(:profile) do
      create(:profile,
      book_notifications: true,
      author_notifications: true,
      publisher_notifications: true,
      genre_notifications: true)
    end
    let!(:another_profile) do
      create(:admin_profile,
      book_notifications: true,
      author_notifications: true,
      publisher_notifications: true,
      genre_notifications: true)
    end

    context 'delete notifications' do
      it 'allows a user to delete a notification' do
        sign_in profile.owner
        Genre.create(
          name: 'Fantasy'
        )
        delete notification_path(Notification.first.id, locale: 'en')
        expect(profile.reload.notifications.count).to eq 0
      end

      it 'does not allow a user to delete a notification from another user' do
        sign_in another_profile.owner
        Genre.create(
          name: 'Fantasy'
        )
        sign_in profile.owner
        delete notification_path(Notification.first.id, locale: 'en')
        expect(another_profile.reload.notifications.count).to eq 1
      end

      it 'allows a user to delete all notifications' do
        sign_in another_profile.owner
        Genre.create(
          name: 'Fantasy'
        )
        Publisher.create(
          name: 'Bla'
        )
        expect(Notification.count).to eq 4
        sign_in profile.owner
        delete delete_all_notifications_path(locale: 'en')
        expect(profile.reload.notifications.count).to eq 0
      end

      it 'does not allow a user to delete all notifications from another user' do
        sign_in another_profile.owner
        Genre.create(
          name: 'Fantasy'
        )
        Publisher.create(
          name: 'Bla'
        )
        expect(Notification.count).to eq 4
        sign_in profile.owner
        delete delete_all_notifications_path(locale: 'en')
        expect(another_profile.reload.notifications.count).to eq 2
      end
    end

    context 'mark notifications as read' do
      it 'allows a user to mark all notifications as read' do
        sign_in another_profile.owner
        Genre.create(
          name: 'Fantasy'
        )
        Publisher.create(
          name: 'Bla'
        )
        expect(profile.reload.notifications.unread.count).to eq 2
        sign_in profile.owner
        post read_notifications_path(locale: 'en')
        expect(profile.reload.notifications.unread.count).to eq 0
      end

      it 'does not allow a user to mark all notifications as read from another user' do
        sign_in another_profile.owner
        Genre.create(
          name: 'Fantasy'
        )
        Publisher.create(
          name: 'Bla'
        )
        expect(profile.reload.notifications.unread.count).to eq 2
        sign_in profile.owner
        post read_notifications_path(locale: 'en')
        expect(another_profile.reload.notifications.unread.count).to eq 2
      end
    end
  end

end
