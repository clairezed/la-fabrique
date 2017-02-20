source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Core ====================================================
gem 'rails', '~> 5.0.1'
gem 'pg'
gem 'puma', '~> 3.0'

# DB / Model ==============================================
gem 'acts_as_list', '~> 0.7.6'
gem 'devise', '~> 4.2.0'
gem 'aasm'

# Uploads ------------------------------------------------
# gem 'paperclip', '~> 4.2'
# gem 'jquery-fileupload-rails'
# gem 'aws-sdk', '< 2.0' # compatibilité paperclip

# View ====================================================
gem 'bootstrap', '~> 4.0.0.alpha3.1'
gem 'autoprefixer-rails', '~> 6.3.7'
gem 'will_paginate', '~> 3.1.0'
gem 'slim', '~> 3.0.7'
gem 'htmlentities', '~> 4.3.4'
gem "font-awesome-rails"

# Assets --------------------------------------------------
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

# pdf -----------------------------------------------------
gem 'prawn'
gem 'prawn-svg'
gem 'prawn-table'

#= NOTIFS =================================
gem 'exception_notification', git: 'git://github.com/smartinez87/exception_notification.git'

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "capistrano"
  gem "rvm-capistrano", require: false
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'email_spec'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'temping'
end
