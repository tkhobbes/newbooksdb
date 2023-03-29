# frozen_string_literal: true

# displays icons to show as list or as grid
class ShowTypeComponent < ViewComponent::Base
  def initialize(model:, existing_scopes:)
    super
    @model = Object.const_get(model)
    @existing_scopes = existing_scopes
  end

  # get full path to toggle between different views
  def full_scope_path(show)
    new_scopes = @existing_scopes.merge(
      letter: params[:letter],
      page: params[:page],
      sort_by: params[:sort_by],
      sort_dir: params[:sort_dir],
      show:
    )
    url_for(action: 'index', controller: controller_name, params: new_scopes)
  end

  private

  # extract the controller name from the model name
  # convert back to string, then downcase, add plural and remove number
  def controller_name
    pluralize(2, @model.to_s.downcase).gsub(/\d /,'')
  end

end
