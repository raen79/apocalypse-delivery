# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails', '~> 6.0.2', '>= 6.0.2.1' 
gem 'pg', '>= 0.18', '< 2.0' 
gem 'puma', '~> 4.1' 
gem 'sass-rails', '>= 6' 
gem 'webpacker', '~> 4.0' 
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7' 

gem 'rspec-rails'

gem 'solidus'
gem 'solidus_auth_devise'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'fog-aws'
gem 'solidus_stripe', '~> 3.0'
gem 'geocoder'

gem 'prawn'
gem 'prawn-table'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'prettier'
  gem 'rubocop', require: false
  gem 'factory_bot_rails'
  gem 'pry-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener' 
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver' # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'shoulda-matchers'
  gem 'database_cleaner-active_record'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
