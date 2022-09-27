class ShelvesController < ApplicationController

  def edit

  end

  def update

  end

  def new

  end

  def create

  end

  def destroy

  end

  private

  def shelf_params
    params.require(:shelf).permit(:name)
  end
end
