# frozen_string_literal: true

# this component generates a sort button with arrows pointing up or down
# depending on whether sorted ascending or descending, or no arrow if no sort applied
class SortComponent < ViewComponent::Base
  def initialize(model:, field:, existing_scopes:)
    super
    @model = Object.const_get(model)
    @existing_scopes = existing_scopes
    @field = field
  end

  # generates the full path for a letter entry, honouring already existing scopes
  def full_scope_path(current_order)
    new_scopes = @existing_scopes.merge(
      sort_by: @field,
      sort_dir: toggle(current_order)
    )
    url_for(action: 'index', controller: controller_name, params: new_scopes)
  end

  def toggle(order)
    if order == 'asc'
      'desc'
    else
      'asc'
    end
  end

  def display_label
    t("SortComponent.#{@model}.#{@field}")
  end

  def sort_icon(field, dir)
    if field == @field.to_s
      if dir == 'asc'
        inline_svg_tag('arrowdown.svg', class: 'smallicon')
      elsif dir == 'desc'
        inline_svg_tag('arrowup.svg', class: 'smallicon')
      else
        inline_svg_tag('arrowsupdown.svg', class: 'smallicon')
      end
    else
      inline_svg_tag('arrowsupdown.svg', class: 'smallicon')
    end
  end

  private

  # extract the controller name from the model name
  # convert back to string, then downcase, add plural and remove number
  def controller_name
    pluralize(2, @model.to_s.downcase).gsub(/\d /,'')
  end

end
