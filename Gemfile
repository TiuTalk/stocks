source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'alphavantagerb'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'business'
gem 'chartkick'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'parallel'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'
gem 'ratelimit'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'uglifier', '>= 1.3.0'

group :production do
  gem 'sentry-raven'
  gem 'skylight', '4.0.0.beta'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.8'
  gem 'rspec_junit_formatter'
  gem 'rubocop', require: false
end

group :development do
  gem 'bundler-audit'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'climate_control'
  gem 'fakeredis'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '4.0.0.rc1'
  gem 'simplecov', require: false
  gem 'vcr', require: false
  gem 'webmock'
end
