# frozen_string_literal: true

# Standard Rails controller for the tag model
# this class smells of :reek:TooManyInstanceVariables
class TagsController < ApplicationController
  # allow for turbo frame variants
  before_action :turbo_frame_request_variant

  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_owner!, only: [:index, :new, :create, :edit, :update, :destroy]

  before_action :dissolve, only: [:show]

  # index method only lists tags from the currently logged in owner by default
  # if param[:show] is settings, will allow owners to manage their tags
  # if param[:show] is admin, will allow an admin to administer all tags
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # this method smells of :reek:TooManyStatements
  # this method smells of :reek:DuplicateMethodCall
  def index
    if params[:show] == 'settings'
      @tags = if current_owner&.admin
                Tag.all.order(:name).includes([owner: [:profile]])
              else
                current_owner.tags.includes([:owner]).order(:owner)
              end
      render 'admin', tags: @tags
    else
      case params[:list]
      when 'authors'
        @pagy, @tags = pagy(Tag
          .where(owner_id: current_owner.id)
          .includes([authors: [portrait_attachment: :blob]])
          .order(:name))
      else
        @pagy, @tags = pagy(Tag
          .where(owner_id: current_owner.id)
          .includes([books: [cover_attachment: :blob]])
          .order(:name))
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  # standard rails show method to display a tag and get all books within that tag
  def show
    if current_owner == @tag.owner || current_owner&.admin
      case params[:list]
      when 'books'
        @pagy, @books = pagy(@tag.books.includes([:authors, :owner, cover_attachment: :blob]).order(:sort_title))
      when 'authors'
        @pagy_authors, @authors = pagy(@tag.authors.includes([portrait_attachment: :blob]).order(:sort_name))
      end
    else
      redirect_to root_path,
        error: "You are not authorised to view this #{Tag.model_name.human}"
    end
  end

  #new action - displayed in a turbo frame within the settings page
  def new
    @tag = Tag.new
  end

  #edit action - displayed in a turbo frame within the settings page
  def edit
    redirect_to root_path,
    error: 'You are not authorised to edit this tag' unless @tag.owner == current_owner || current_owner&.admin
  end

  #standard rails create action; answers to:
  # -normal html (fallback and not used)
  # -turbo stream - default response format, used on the settings page
  # -json - used as we can create formats on the fly in the book form
  # This method smells of :reek:DuplicateMethodCall
  # This method smells of :reek:TooManyStatements
  # rubocop:disable Metrics/MethodLength
  def create
    @tag = Tag.new(tag_params)
    @tag.owner_id = current_owner.id
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
  # rubocop:enable Metrics/MethodLength

  #standard rails update action - can only be used from within turbo frames
  def update
    if @tag.owner == current_owner || current_owner&.admin
      if @tag.update(tag_params)
        redirect_to(tags_path(show: 'settings'))
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to root_path,
        error: "You are not authorised to edit this tag #{Tag.model_name.human}"
    end
  end

  #standard rails destroy action - responds to
  # -html (not used)
  # -turbo-stream - default response format, used on the settings page
  # the method also takes care of destroying the taggings in scope (as tags are polymorphic)
  # This method smells of :reek:TooManyStatements
  def destroy
    if @tag.owner == current_owner || current_owner&.admin
      Tagging.where(tag_id: @tag.id).find_each(&:destroy)
      @tag.destroy
      if @tag.destroyed?
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to tags_path, show: 'books', status: :see_other }
        end
      else
        # in the rare occasion where the format is not deleted -
        # as it is the default - ensure that the corresponding
        # turbo stream is not removed
        render json: { nothing: true }
      end
    else
      redirect_to root_path,
        error: "You are not authorised to delete this #{Tag.model_name.human}"
    end
  end

  private

  # standard rails method to find a tag
  def set_tag
    @tag = Tag.friendly.find(params[:id])
  end

  # strong parameters
  def tag_params
    params.require(:tag).permit(:name, :owner_id)
  end
end
