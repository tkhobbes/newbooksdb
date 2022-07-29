# frozen_string_literal: true

Backpedal.configure do |config|
  config.skipped_verbs = ['new', 'edit', 'destroy']
end
