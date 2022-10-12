# frozen_string_literal: true

# controller that takes unused items of a model, displays them and destroys them
class UnusedItemsController < ApplicationController

  # show method shows all unused items of a model
  def index
    @model = params[:items_in]
    @items = Object.const_get(@model).send(params[:show])
  end

  # destroy method actually deletes unused items of a model
  def destroy
    model = params[:items_in]
    Object.const_get(model).send(params[:show]).destroy_all
    redirect_to bulk_actions_settings_path, notice: "Unused #{model}s removed."
  end
end
