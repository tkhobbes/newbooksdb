source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Rails & Core Gems
gem "rails", "~> 7.0.3"
gem "puma", "~> 5.6.4"
gem "jbuilder", "~> 2.11.5"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails", "~> 6.0.0.rc1"
  gem "faker", "~> 2.21"
  gem 'factory_bot_rails', '~> 6.2'
end

group :development do
  gem "web-console"
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Dev Tools
  gem "annotate", "~> 3.2"
  gem "solargraph", "~> 0.45.0"
  gem "solargraph-rails", "~> 0.3.1"
  gem "yard", "~> 0.9.28"
  gem "rubocop", " ~> 1.30.1"
  gem "rubocop-rails", "~> 2.14.2"
  gem "rubocop-performance", " ~> 1.14.2"
  gem 'reek', '~> 6.1', '>= 6.1.1'
  gem "rails-erd", "1.7.0"
  gem "bullet", "~> 7.0.2"
  gem 'database_consistency', '~> 1.1', '>= 1.1.15'
end

group :test do
gem 'simplecov', '~> 0.21.2'
end

# Database
gem "mysql2", "~> 0.5.4"
gem "redis", "~> 4.6.0"
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Turbo and Stimulus
gem "turbo-rails", "~> 1.1.1"
gem "stimulus-rails", "~> 1.0.4"

# Assets, Javascript, CSS
gem "sprockets-rails", "~> 3.4.2"
gem "jsbundling-rails", "~> 1.0.2"
gem "cssbundling-rails", "~> 1.1.0"
# Use Sass to process CSS
# gem "sassc-rails"

# Image processing etc
gem "image_processing", "~> 1.12.2"


# Core application Gems
