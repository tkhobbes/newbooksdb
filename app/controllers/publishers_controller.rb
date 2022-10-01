#frozen_string_literal: true

# Standard Rails model for Publishers
class PublishersController < ApplicationController
  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  # index method uses pagy
  def index
    @pagy, @publishers = pagy(Publisher.all
      .includes([books: [cover_attachment: :blob]])
      .order(:name))
  end

  private

  # Rails strong params
  def publisher_params
    params.require(:publisher).permit(:name, :location)
  end

  # standard method to get the publisher using friendly ID
  def set_publisher
    @publisher = Publisher.friendly.find(params[:id])
  end
end
