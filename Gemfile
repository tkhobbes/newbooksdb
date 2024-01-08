# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.1'

# Rails & Core Gems
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1', '>= 3.1.18'
gem 'bootsnap', require: false
gem 'jbuilder', '~> 2.11.5'
gem 'puma', '~> 5.6.4'
gem 'rails', '~> 7.0.3'
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem 'capybara', '>= 3.37.1'
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rails-controller-testing', '>= 1.0.5'
  gem 'rspec-rails'
  gem 'webdrivers'
end

group :development do
  gem 'web-console'
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Dev Tools
  gem 'annotate'
  gem 'better_errors', '>= 2.9.1'
  gem 'binding_of_caller' # required for better_errors
  gem 'brakeman'
  gem 'bullet'
  gem 'database_consistency', '>= 1.1.15'
  gem 'erb_lint'
  gem 'i18n-debug'
  gem 'letter_opener', '>= 1.8.1'
  gem 'prosopite'
  gem 'rails-erd'
  gem 'reek', '>= 6.1.1'
  gem 'rubocop', require: false
  gem 'rubocop-md', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', '>= 2.11.1', require: false
  gem 'solargraph'
  gem 'solargraph-rails'
end

group :test do
  gem 'database_cleaner-active_record', '>= 2.0.1'
  gem 'simplecov'
end

# Database
gem 'mysql2', '~>0.5'
gem 'redis', '~> 4.6.0'
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
gem 'kredis', '~> 1.3'

# Turbo and Stimulus
gem 'stimulus-rails'
gem 'turbo-rails'

# Assets, Javascript, CSS
gem 'cssbundling-rails', '~> 1.1.0'
gem 'jsbundling-rails', '~> 1.0.2'
gem 'requestjs-rails', '~> 0.0.9'
gem 'sprockets-rails', '~> 3.4.2'

# Image processing etc
gem 'image_processing'

# Core application Gems
# go back to previous pages easily
gem 'backpedal', git: 'https://github.com/tkhobbes/backpedal'
# charts and statistics
gem 'chartkick', git: 'https://github.com/tkhobbes/chartkick.git'
# country selection for books
gem 'country_select'
# authentication with devise
gem 'devise', '~> 4.8', '>= 4.8.1'
# i18n for devise
gem 'devise-i18n'
# exception notifications - loaded everywhere but initializer will only kick in for production environment
gem 'exception_notification'
# Faraday for safer http requests
gem 'faraday', '>= 2.7.1'
# use nice IDs instead of numbers
gem 'friendly_id', '>= 5.4.2'
# group dates for charts
gem 'groupdate'
# using scoped routes for our shelves etc
gem 'has_scope'
# check i18n keys
gem 'i18n-tasks', '~> 1.0.12'
# better way to use SVGs
gem 'inline_svg'
# lookbook for viewcomponents
gem 'lookbook'
# mediawiki crawler
gem 'mediawiki-butt'
# web crawler
gem 'metainspector'
# notifications
gem 'noticed'
# wrapper for http requests - using for picture grabbing
gem 'open-uri'
# Pagination for large collections
gem 'pagy', '>= 5.10.1'
# i18n
gem 'rails-i18n'
# Search
gem 'search_cop', '>= 1.2.3'
# Simple form for form inputs
gem 'simple_form'
# view components
gem 'view_component'


