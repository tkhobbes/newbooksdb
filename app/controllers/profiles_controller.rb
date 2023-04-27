# frozen_string_literal: true

# Standard rails controller for profiles
class ProfilesController < ApplicationController
  before_action :authenticate_owner!

  before_action :set_profile, except: :index

  skip_before_action :verify_authenticity_token, only: [:update_locale]

  # we list all profiles / owners through the index action here
  # accessible only for admins and deleting profiles will delete the owners too
  def index
    @profiles = Profile.all.order(:name).includes(:owner, [avatar_attachment: :blob])
  end

  def show; end

  def edit; end

  def update
    if (current_owner.admin || @profile.owner == current_owner) && @profile.update(profile_params)
      redirect_to profile_path(@profile), success: "#{Profile.model_name.human} updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_locale
    @profile.update(userlocale: params[:userlocale])
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:name, :avatar)
  end
end
