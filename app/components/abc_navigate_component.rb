# frozen_string_literal: false

class AbcNavigateComponent < ViewComponent::Base
  # we need HasScope from the gem, and we need to make apply_scopes public
  include HasScope
  public :apply_scopes

  def initialize(model:, existing_scopes:, sort_column:, current_letter:)
    @model = Object.const_get(model)
    @existing_scopes = existing_scopes
    @sort_column = sort_column
    @current_letter = current_letter
    super
  end

  # method generates the abc nav list and returns it as html_safe
  # it cycles through the sort map and uses "output_letter" to generate the html
  # for each nav entry
  def generate_abc_nav
    nav = ''
    sort_map.each do |letter, count|
      nav << span_letter(letter, count)
    end
    nav.html_safe
  end

  # method generates proper html for ONE letter - depending on whether it is active
  # and whether it has any results
  def span_letter(letter, count)
    if count.positive?
      if @current_letter == letter
        content_tag(:span, class: 'single-letter active') do
          letter.upcase
        end
      else
        content_tag(:span, class: 'single-letter') do
          link_to letter.upcase, full_scope_path(letter)
        end
      end
    else
      content_tag(:span, class: 'single-letter') do
        letter.upcase
      end
    end
  end

  # method generates a map for each letter and how many times it occurs in the
  # column that was to be sorted, by mergin in the sort_list hash
  def sort_map
    map = Hash.new(0)
    ('a'..'z').each { |letter| map[letter] = 0 }
    map.merge(sort_list)
  end

  # cycles through the model and returns a hash of the first letter of the
  # sort column and how many times it occurs ('a' => 3, 'b' => 2, etc.)
  def sort_list
    if @existing_scopes.present?
      @model.send(@existing_scopes.keys.first, @existing_scopes.values.first)
        .pluck(@sort_column) # array of sort_column values
        &.map { |sort| sort[0].downcase } # array of first letter of sort_column values
        &.tally # hash of first letter of sort_column values and their count (e.g. 'a' => 3, 'b' => 2, etc.)
    else
      @model.pluck(@sort_column)&.map { |sort| sort[0].downcase }&.tally&.sort.to_h
    end
  end

  # generates the full path for a letter entry, honouring already existing scopes
  def full_scope_path(letter)
    new_scopes = @existing_scopes.merge(letter:)
    url_for(action: 'index', controller: controller_name, params: new_scopes)
  end

  private

  # extract the controller name from the model name
  # convert back to string, then downcase, add plural and remove number
  def controller_name
    pluralize(2, @model.to_s.downcase).gsub(/\d /,'')
  end

end
