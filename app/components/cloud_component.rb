# frozen_string_literal: true

# this component generates a cloud based on how many books are in <model>
# <model> must have a "Name", and a "books_count" field
class CloudComponent < ViewComponent::Base

  def initialize(model:)
    super
    @model = Object.const_get(model)
  end

  # generate a hash of genres and their size
  # this method smells of :reek:TooManyStatements
  def cloud
    cloud_data = []
    @model.all.each do |m|
      one_item = {}
      one_item[:name] = m.name
      one_item[:size] = m.books_count
      one_item[:id] = m.id
      cloud_data << one_item
    end
    cloud_data
  end

  # map actual sizes to manageable sizes (10 buckets)
  def cloudsize(a_size, maxsize)
    # size is the ratio rounded up to the next tenth (15 --> 10, 21 --> 20 etc)
    # and then size is divided by 10 to get the bucket
    (a_size / maxsize.to_f * 100).round.to_i.ceil(-1) / 10
  end

  # generates the path for the cloud item
  def item_path(id)
    url_for(@model.find(id))
  end

  private

  # extract the controller name from the model name
  # convert back to string, then downcase, add plural and remove number
  def controller_name
    pluralize(2, @model.to_s.downcase).gsub(/\d /,'')
  end

end
