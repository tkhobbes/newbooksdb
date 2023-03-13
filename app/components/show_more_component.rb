# frozen_string_literal: true

# shows a link to "show more" for items of a certain type
class ShowMoreComponent < ViewComponent::Base

  def initialize(model:, id:, items:, items_type: 'books')
    @model = Object.const_get(model)
    super
    @id = id
    @items = items
    @items_type = items_type
  end

  def show_more
    if @items.empty?
      "No #{@items_type} for this #{@model.to_s.downcase}"
    else
      link_to "Show all (#{@items.size} books)...", show_path
    end
  end

  private

  def show_path
    "#{@model.to_s.downcase}s/#{@id}"
  end

end
