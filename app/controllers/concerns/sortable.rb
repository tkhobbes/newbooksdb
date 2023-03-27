# frozen_string_literal: true

# makes sortable views available for a controller

module Sortable
  extend ActiveSupport::Concern

  # orders the book based on params
  def order(default_sort, collection)
    if params[:sort_by]
      collection.order("#{params[:sort_by]} #{params[:sort_dir]}")
    else
      collection.order(default_sort)
    end
  end
end
