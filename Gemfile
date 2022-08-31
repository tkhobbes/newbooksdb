# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Rails & Core Gems
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1', '>= 3.1.18'
gem 'bootsnap', require: false
gem 'jbuilder', '~> 2.11.5'
gem 'puma', '~> 5.6.4'
gem 'rails', '~> 7.0.3'
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem 'capybara', '~> 3.37', '>= 3.37.1'
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.21'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'rspec-rails', '~> 6.0.0.rc1'
  gem 'webdrivers', '~> 5.0'
end

group :development do
  gem 'web-console'
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Dev Tools
  gem 'annotate', '~> 3.2'
  gem 'better_errors', '~> 2.9', '>= 2.9.1'
  gem 'binding_of_caller', '~> 1.0' # required for better_errors
  gem 'bullet', '~> 7.0.2'
  gem 'database_consistency', '~> 1.1', '>= 1.1.15'
  gem 'rails-erd', '1.7.0'
  gem 'reek', '~> 6.1', '>= 6.1.1'
  gem 'rubocop', ' ~> 1.30.1', require: false
  gem 'rubocop-performance', ' ~> 1.14.2', require: false
  gem 'rubocop-rails', '~> 2.14.2', require: false
  gem 'rubocop-rspec', '~> 2.11', '>= 2.11.1', require: false
  gem 'solargraph', '~> 0.45.0'
  gem 'solargraph-rails', '~> 0.3.1'
  gem 'yard', '~> 0.9.28'
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.0', '>= 2.0.1'
  gem 'simplecov', '~> 0.21.2'
end

# Database
gem 'mysql2', '~> 0.5.4'
gem 'redis', '~> 4.6.0'
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Turbo and Stimulus
gem 'stimulus-rails', '~> 1.0.4'
gem 'turbo-rails', '~> 1.1.1'

# Assets, Javascript, CSS
gem 'cssbundling-rails', '~> 1.1.0'
gem 'jsbundling-rails', '~> 1.0.2'
gem 'requestjs-rails', '~> 0.0.9'
gem 'sprockets-rails', '~> 3.4.2'

# Image processing etc
gem 'image_processing', '~> 1.12.2'

# Core application Gems
# go back to previous pages easily
gem 'backpedal', '~> 0.2.1'
# use nice IDs instead of numbers
gem 'friendly_id', '~> 5.4', '>= 5.4.2'
# Pagination for large collections
gem 'pagy', '~> 5.10', '>= 5.10.1'
# Simple form for form inputs
gem 'simple_form', '~> 5.1'
