# frozen-string_literal: true

# standard rails controller for shelves; these actions are all only used within the
# settings menu
class ShelvesController < ApplicationController
  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  before_action :set_shelf, only: [:show, :edit, :update, :destroy]

  # we need the session helper and the user concerns to ensure only logged in users can tamper with formats
  include SessionsHelper
  include UserConcerns

  before_action :logged_in_user
  before_action :correct_or_admin_user, only: [:edit, :update, :destroy]

  before_action :dissolve

  # lists all shelves - only user owned if user is not admin
  def index
    if current_user.admin?
      @shelves = Shelf.all.order(:name).includes([:user])
    else
      @shelves = current_user.shelves.all.order(:name).includes([:user])
    end
  end

  # standard rails method to edit a shelf
  def edit; end

  def update
    if @shelf.update(shelf_params)
      redirect_to shelves_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Standard rails new action
  def new
    @shelf = Shelf.new
  end

  #standard rails create action; answers to:
  # -normal html (fallback and not used)
  # -turbo stream - default response format, used on the settings page
  # -json - used as we can create formats on the fly in the book form
  # This method smells of :reek:DuplicateMethodCall
  # This method smells of :reek:TooManyStatements
  def create
    @shelf = Shelf.new(shelf_params)
    @shelf.user_id = current_user.id

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


  #standard rails destroy action - responds to
  # -html (not used)
  # -turbo-stream - default response format, used on the settings page
  # This method smells of :reek:TooManyStatements
  def destroy
   @shelf.destroy
    if @shelf.destroyed?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to shelves, status: :see_other }
      end
    else
      # in the rare occasion where the format is not deleted -
      # as it is the default - ensure that the corresponding
      # turbo stream is not removed
      render json: { nothing: true }
    end
  end

  private
  # confirms the correct user, or user is an admin
  def correct_or_admin_user
    return if current_user.admin?
    @user = @shelf.user
    redirect_to(root_path, status: :see_other) unless current_user?(@user)
  end

  # rails strong params
  def shelf_params
    params.require(:shelf).permit(:name)
  end

  # set shelf consistently
   def set_shelf
    @shelf = Shelf.find(params[:id])
  end
end
