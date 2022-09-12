# frozen_string_literal: true

# Module assembles methods that deal with user authentication
module UserConcerns
    extend ActiveSupport::Concern

  # confirms a logged-in user
  def logged_in_user
    return if logged_in?
    store_location
    flash[:warning] = 'Please log in'
    redirect_to login_path, status: :see_other
  end

end
