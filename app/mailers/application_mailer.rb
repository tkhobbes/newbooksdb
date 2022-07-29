# frozen_string_literal: true

# Standard Rails Application Mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
