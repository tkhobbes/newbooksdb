# frozen_string_literal: true

# this service class attaches pictures via active storage
class PictureAttacher
  attr_accessor :picture_url, :attachment_field

  def initialize(picture_url, attachment_field)
    @picture_url = picture_url
    @attachment_field = attachment_field
  end

  def attach
    return if @picture_url.nil? || @picture_url.empty?
    # find the picture
    picture_attach = URI.open(@picture_url)
    # workaround if file is too small
    # found here: https://gist.github.com/janko/7cd94b8b4dd113c2c193
    if picture_attach.is_a?(StringIO)
        tempfile = Tempfile.new("open-uri", binmode: true)
        IO.copy_stream(picture_attach, tempfile.path)
        picture_attach = tempfile
    end
    picture_name = File.basename(picture_attach.path)
    @attachment_field.attach(io: picture_attach, filename: picture_name)

  end
end
