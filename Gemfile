source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'alphavantagerb'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '4.0.0.rc1'
end
