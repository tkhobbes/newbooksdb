# frozen_string_literal: true

# standard rails controller for shelves; these actions are all only used within the
# settings menu
class ShelvesController < ApplicationController
  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  before_action :set_shelf, only: [:edit, :update, :destroy]

  before_action :authenticate_owner!

  before_action :dissolve

  # lists all shelves - only owner owned if owner is not admin
  def index
    @shelves = if current_owner.admin
                Shelf.all.order(:name).includes([owner: [:profile]])
              else
                current_owner.shelves.all.order(:name).includes([:owner])
              end
  end


  # Standard rails new action
  def new
    @shelf = Shelf.new
  end

  # standard rails method to edit a shelf
  def edit
    redirect_to root_path,
    error: 'You are not authorised to edit this shelf' unless @shelf.owner == current_owner || current_owner.admin
  end

  #standard rails create action; answers to:
  # -normal html (fallback and not used)
  # -turbo stream - default response format, used on the settings page
  # -json - used as we can create formats on the fly in the book form
  # This method smells of :reek:DuplicateMethodCall
  # This method smells of :reek:TooManyStatements
  # rubocop:disable Metrics/MethodLength
  def create
    @shelf = Shelf.new(shelf_params)
    @shelf.owner_id = current_owner.id

    respond_to do |format|
      if @shelf.save
        format.turbo_stream
        format.html { redirect_to shelves_path }
        format.json { render json: @shelf }
      else
        format.html { render :new, status: :unprocessable_entity }
      end

    end
  end
# rubocop:enable Metrics/MethodLength

  def update
    if @shelf.owner == current_owner || current_owner.admin
      if @shelf.update(shelf_params)
        redirect_to shelves_path
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to root_path, error: 'You are not authorised to edit this shelf'
    end
  end

  #standard rails destroy action - responds to
  # -html (not used)
  # -turbo-stream - default response format, used on the settings page
  # This method smells of :reek:TooManyStatements
  def destroy
    if @shelf.owner == current_owner || current_owner.admin
      @shelf.destroy
      if @shelf.destroyed?
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to shelves_path, status: :see_other }
        end
      else
        # in the rare occasion where the format is not deleted -
        # as it is the default - ensure that the corresponding
        # turbo stream is not removed
        render json: { nothing: true }
      end
    else
      redirect_to root_path,
    error: 'You are not authorised to delete this shelf'
    end
  end

  private

  # rails strong params
  def shelf_params
    params.require(:shelf).permit(:name)
  end

  # set shelf consistently
   def set_shelf
    @shelf = Shelf.find(params[:id])
  end
end
