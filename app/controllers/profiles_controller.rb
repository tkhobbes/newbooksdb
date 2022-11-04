# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_owner!

  before_action :set_profile, except: :index

  # we list all profiles / owners through the index action here
  # accessible only for admins and deleting profiles will delete the owners too
  def index
    @profiles = Profile.all.order(:name).includes([avatar_attachment: :blob])
  end

  def show; end

  def edit; end

  def update
    if @profile.update(profile_params)
      redirect_to(profile_path(@profile))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:name, :avatar)
  end
end
