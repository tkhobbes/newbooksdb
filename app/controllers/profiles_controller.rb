# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_owner!

  before_action :set_profile

  def show

  end

  def edit

  end

  def update

  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:name, :avatar)
  end
end
