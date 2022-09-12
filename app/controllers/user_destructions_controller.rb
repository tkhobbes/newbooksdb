# frozen_string_literal: true

# Controller to handle logic behind user destruction; no model
class UserDestructionsController < ApplicationController

  # show the form
  def new
    @user = User.find(params[:id])
  end

  # decide what to do with the books and then destroy the user
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # This method smells of :reek:TooManyStatements
  # This mehod smells of :reek:DuplicateMethodCall
  def create
    user = User.find(params[:current_user_id])
    # are we even allowed to do that?
    redirect_to root_path unless current_user.admin? || current_user?(user)
    # transfer books to another user
    case params[:book_selection]
    when 'transfer'
      transfer_books(user, User.find_by(email: params[:transfer_to_user]))
      action_message = "books transferred to user #{params[:transfer_to_user]}"
    when 'delete'
      delete_books(user)
      action_message = 'books removed'
    end
    user.destroy
    redirect_to root_path, info: "Profile destroyed; #{action_message}"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  # transfer books to another user
  # this method smells of :reek:UtilityFunction
  def transfer_books(old_user, new_user)
    old_user.books.each do |book|
      book.update(user_id: new_user.id)
    end
  end

  # delete books
  # This method smells of :reek:UtilityFunction
  def delete_books(user)
    Books.delete_all(where: { user_id: user.id })
  end

end
