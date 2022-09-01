# frozen_string_literal: true

Rails.application.config.generators do |g|
  g.test_framework :rspec,
    fixtures: false,
    view_specs: false,
    routing_specs: false,
    request_specs: false
end
