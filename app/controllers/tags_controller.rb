# frozen_string_literal: true

# Standard Rails controller for the tag model
class TagsController < ApplicationController
  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # we need the session helper and the user concerns to ensure only logged in users can tamper with formats
  include SessionsHelper
  include UserConcerns

  before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :correct_or_admin_user, only: [:show, :edit, :update, :destroy]

  before_action :dissolve, only: [:show]

  # index method only lists tags from the currently logged in user by default
  # if param[:show] is settings, will allow user to manage their tags
  # if param[:show] is admin, will allow an admin to administer all tags

  def index
    @user = current_user
    case params[:show]
    when 'settings'
      if current_user.admin?
        @tags = Tag.all.order(:name).includes([:user])
      else
        @tags = @user.tags.includes([:user]).order(:name)
      end
      render 'admin', tags: @tags
    when 'unused'
      @tags = Tag.no_books.order(:name)
      render 'admin'
    else
      @pagy, @tags = pagy(Tag
        .where(user_id: @user.id)
        .includes([:books_tags, books: [cover_attachment: :blob]])
        .order(:name))
    end
  end

  # standard rails show method to display a tag and get all books within that tag
  def show
    @pagy, @books = pagy(@tag.books.includes([:user, cover_attachment: :blob]))
  end

  #new action - displayed in a turbo frame within the settings page
  def new
    @tag = Tag.new
  end

  #standard rails create action; answers to:
  # -normal html (fallback and not used)
  # -turbo stream - default response format, used on the settings page
  # -json - used as we can create formats on the fly in the book form
  # This method smells of :reek:DuplicateMethodCall
  # This method smells of :reek:TooManyStatements
  def create
    @tag = Tag.new(tag_params)
    @tag.user_id = current_user.id

    respond_to do |format|
      if @tag.save
        format.turbo_stream
        format.html { redirect_to tag_path(@tag) }
        format.json { render json: @tag }
      else
        format.html { render :new, status: :unprocessable_entity }
      end

    end
  end

  #edit action - displayed in a turbo frame within the settings page
  def edit; end

  #standard rails update action - can only be used from within turbo frames
  def update
    if @tag.update(tag_params)
      params[:show] == 'settings' ? redirect_to(tags_path(show: 'settings')) : redirect_to(tags_path(show: 'admin'))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  #standard rails destroy action - responds to
  # -html (not used)
  # -turbo-stream - default response format, used on the settings page
  # This method smells of :reek:TooManyStatements
  def destroy
    @tag.destroy
    if @tag.destroyed?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to tags, status: :see_other }
      end
    else
      # in the rare occasion where the format is not deleted -
      # as it is the default - ensure that the corresponding
      # turbo stream is not removed
      render json: { nothing: true }
    end
  end

  # removes all unused tags
  def remove_unused
    Tag.no_books.destroy_all
    redirect_to bulk_actions_settings_path, notice: 'Unused Tags removed.'
  end

  private

    # confirms the correct user
  def correct_or_admin_user
    return if current_user.admin?
    @user = @tag.user
    redirect_to(root_path, status: :see_other) unless current_user?(@user)
  end

  # confirms a admin user
  def admin_user
    redirect_to root_path, status: :see_other unless current_user.admin?
  end

  # standard rails method to find a tag
  def set_tag
    @tag = Tag.friendly.find(params[:id])
  end

  # strong parameters
  def tag_params
    params.require(:tag).permit(:name, :user_id)
  end
end
