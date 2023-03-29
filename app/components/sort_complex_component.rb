# frozen_string_literal: true

# this component generates a sort button with arrows pointing up or down
# depending on whether sorted ascending or descending, or no arrow if no sort applied
# it can be used to sort on associated models
# this method smells of :reek:InstanceVariableAssumption
class SortComplexComponent < SortComponent
  def initialize(model:, field:, existing_scopes:, associated_model:)
    @associated_model = Object.const_get(associated_model)
    # for the other fields, we can use the existing component
    # note however that @field will be a sort fiels of @associated_model
    super(model:, field:, existing_scopes:)
  end

  # generates the full path for a letter entry, honouring already existing scopes
  def full_scope_path(current_order)
    new_scopes = @existing_scopes.merge(
      sort_by: @field,
      sort_dir: toggle(current_order)
    )
    # we somehow need to tell the controller that we want to sort on
    # an associated model - something like this will work:
    # model.joins(:associated_model).order(@field)
    # Book.joins(:authors).order(:sort_name)
    url_for(action: 'index', controller: controller_name, params: new_scopes)
  end

  private

  def associate_controller_name
    pluralize(2, @associated_model.to_s.downcase).gsub(/\d /,'')
  end
end
