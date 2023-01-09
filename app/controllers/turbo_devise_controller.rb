# frozen_string_literal: true

class TurboDeviseController < ApplicationController
  class Responder < ActionController::Responder
    # this method smells of :reek:TooManyStatements
    # This method smells of :reek:UncommunicativeVariableName
    def to_turbo_stream
      if @default_response
        @default_response.call(options.merge(formats: :html))
      else
        controller.render(options.merge(formats: :html))
      end
    rescue ActionView::MissingTemplate => e
      # rubocop:disable Style/GuardClause
      if get?
        raise e
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
      # rubocop:enable Style/GuardClause
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream
end
