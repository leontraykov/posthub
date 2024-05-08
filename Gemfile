# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.0'

gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails'
  gem 'faker', '~> 3.3'
end

group :test do
  gem 'n_plus_one_control'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 5.0.0'
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end
