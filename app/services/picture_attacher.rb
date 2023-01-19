# frozen_string_literal: true

# this service class attaches pictures via active storage
class PictureAttacher

  def initialize(picture_url, attachment_field)
    @picture_url = picture_url
    @attachment_field = attachment_field
  end

  # this method smells of :reek:TooManyStatements
  # rubocop:disable Metrics/MethodLength
  def attach
    return if @picture_url.blank?
    begin
      # find the picture
      picture_attach = URI.parse(@picture_url).open
    rescue OpenURI::HTTPError
      return ReturnPicture.new(created: false, msg: 'Could not read picture')
    end
    # workaround if file is too small
    # found here: https://gist.github.com/janko/7cd94b8b4dd113c2c193
    if picture_attach.is_a?(StringIO)
        tempfile = Tempfile.new('open-uri', binmode: true) do
          IO.copy_stream(picture_attach, tempfile.path)
          picture_attach = tempfile
        end
    end
    picture_name = File.basename(picture_attach.path)
    picture = @attachment_field.attach(io: picture_attach, filename: picture_name)
    ReturnPicture.new(created: true, msg: 'Picture attached.', picture:)
  end
  # rubocop:enable Metrics/MethodLength

  # return object
  class ReturnPicture
    attr_reader :picture, :message

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
