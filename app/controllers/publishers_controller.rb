#frozen_string_literal: true

class PublishersController < ApplicationController

  def index
    @pagy, @publishers = pagy(Publisher.all
      .includes([books: [cover_attachment: :blob]])
      .order(:name))
  end

  private

  def publisher_params
    params.require(:publisher).permit(:name, :location)
  end

  def set_publisher
    @publisher = Publisher.friendly.find(params[:id])
  end
end
