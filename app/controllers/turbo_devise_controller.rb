# frozen_string_literal: true

class TurboDeviseController < ApplicationController
  class Responder < ActionController::Responder
    # this method smells of :reek:TooManyStatements
    # This method smells of :reek:UncommunicativeVariableName
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => e
      # rubocop:disable Style/GuardClause
      if get?
        raise e
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        #navigation_location ||= root_path
        redirect_to navigation_location
      end
      # rubocop:enable Style/GuardClause
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream
end
