# frozen_string_literal: true

# Controller to handle logic behind user destruction; no model
class UserDestructionsController < ApplicationController

  # show the form
  def new
    @user = User.find(params[:id])
  end

  # decide what to do with the books and then destroy the user
  def create
    @user = User.find(params[:userid])
    # are we even allowed to do that?
    redirect_to root_path unless current_user.admin? || current_user?(@user)
    # transfer books to another user
    if params[:book_selection] == 'transfer'
      transfer_books(User.find_by(email: params[:user]))
      action_message = 'books transferred to user ' + params[:user]
    elsif params[:book_selection] == 'delete'
      delete_books
      action_message = 'books removed'
    end
    @user.destroy
    redirect_to root_path, info: 'Profile destroyed; ' + action_message
  end

  private

  # transfer books to another user
  def transfer_books(new_user)
    @user.books.each do |book|
      book.update(user_id: new_user.id)
    end
  end

  # delete books
  def delete_books
    Books.delete_all(where: { user_id: @user.id })
  end

end
