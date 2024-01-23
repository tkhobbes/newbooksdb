# frozen_string_literal: true

# this service class attaches pictures via active storage
class PictureAttacher
  def initialize(picture_url, attachment_field)
    @picture_url = picture_url
    @attachment_field = attachment_field
  end

  # this method smells of :reek:TooManyStatements
  def attach
    return if @picture_url.blank?

    # download picture
    begin
      tempfile = Down.download(@picture_url, extension: 'jpg')
    rescue Down::Error
      return ReturnPicture.new(created: false, msg: 'Could not read picture')
    end
    picture = @attachment_field.attach(io: tempfile, filename: 'picture.jpg')
    ReturnPicture.new(created: true, msg: 'Picture attached.', picture:)
  end

  # return object
  class ReturnPicture
    attr_reader :picture, :message

    # this method smells of :reek:BooleanParameter
    def initialize(created: false, msg: '', picture: nil)
      @created = created
      @message = msg
      @picture = picture
    end

    def created?
      @created
    end
  end
end
