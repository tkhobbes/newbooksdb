# frozen_string_literal: true

# Standard Rails Application Mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'tkhobbes@gmail.com'
  layout 'mailer'
end
