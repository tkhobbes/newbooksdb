# frozen_string_literal: true

# Standard Rails Application Helper
# includes the Pagy Frontent helper
module ApplicationHelper
  include Pagy::Frontend

  # figures out what path we need to show for the user menu in the title
  def login_or_user_path
    logged_in? ? user_path(current_user) : login_path
  end
end
