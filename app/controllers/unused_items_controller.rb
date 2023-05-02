# frozen_string_literal: true

# controller that takes unused items of a model, displays them and destroys them
class UnusedItemsController < ApplicationController
  ALLOWED_METHODS = ['no_books', 'no_taggings'].freeze

  # show method shows all unused items of a model
  # this method smells of :reek:DuplicateMethodCall
  def index
    unless ALLOWED_METHODS.include?(params[:show]) && current_owner&.admin
      redirect_to root_path, notice: 'You are not allowed to perform that action'
    end
    @model = params[:items_in]
    @items = Object.const_get(@model).send(params[:show])
  end

  # destroy method actually deletes unused items of a model
  def destroy
    if current_owner&.admin
      model = params[:items_in]
      Object.const_get(model).send(params[:show]).destroy_all
      redirect_to bulk_actions_settings_path, notice: "Unused #{model}s removed."
    else
      redirect_to root_path, notice: 'You are not allowed to perform that action'
    end
  end
end
