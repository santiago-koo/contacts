source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'awesome_print'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'
  gem 'ffaker', '~> 2.18'
  gem 'hirb'
  gem 'pry', '~> 0.12.2'
  gem 'rspec-rails', '~> 4.0', '>= 4.0.2'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'annotate', '~> 3.1', '>= 3.1.1'
  gem 'letter_opener', '~> 1.7'
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 4.1.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1', '>= 2.1.1'
  gem 'spring-watcher-listen', '~> 2.0', '>= 2.0.1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'database_cleaner-active_record', '~> 2.0'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 4.5', '>= 4.5.1'
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'timecop', '~> 0.9.4'
  gem 'webdrivers'
end

gem 'charlock_holmes', '~> 0.7.7'
gem 'credit_card_detector', '~> 0.4'
gem 'devise', '~> 4.7', '>= 4.7.3'
gem 'haml-rails', '~> 2.0', '>= 2.0.1'
gem 'oj', '~> 3.11', '>= 3.11.2'
gem 'pagy', '~> 3.11'
gem 'redis-namespace', '~> 1.8', '>= 1.8.1'
gem 'sidekiq', '~> 6.1', '>= 6.1.3'
gem 'simple_form', '~> 5.1'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
