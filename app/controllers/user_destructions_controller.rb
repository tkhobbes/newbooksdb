# frozen_string_literal: true

# Controller to handle logic behind owner destruction; no model
class UserDestructionsController < ApplicationController

  # show the form
  def new
    redirect_to root_path, notice: 'You are not authorized to perform that action' unless current_owner
    @owner = Owner.find(Profile.find(params[:id]).owner.id)
  end

  # decide what to do with the books and then destroy the owner
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # This method smells of :reek:TooManyStatements
  # This mehod smells of :reek:DuplicateMethodCall
  def create
    owner = Owner.find(params[:current_owner_id])
    # are we even allowed to do that?
    if current_owner&.admin || owner == current_owner
      # transfer books to another owner
      case params[:book_selection]
      when 'transfer'
        transfer_books(owner, Owner.find_by(email: params[:transfer_to_owner]))
        action_message = "books transferred to owner #{params[:transfer_to_owner]}"
      when 'delete'
        delete_books(owner)
        action_message = 'books removed'
      end
      owner.destroy
      redirect_to root_path, info: "Owner Removed; #{action_message}"
    else
      redirect_to root_path
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  # transfer books to another owner
  # this method smells of :reek:UtilityFunction
  def transfer_books(old_owner, new_owner)
    old_owner.books.each do |book|
      book.update(owner_id: new_owner.id)
    end
  end

  # delete books
  # This method smells of :reek:UtilityFunction
  def delete_books(existing_owner)
    Book.destroy_by(owner: existing_owner)
  end

end
