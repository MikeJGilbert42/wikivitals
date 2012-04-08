source 'https://rubygems.org'

gem 'rails', '3.2.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

# Deploy with Capistrano
# gem 'capistrano'

group :test do
  gem "rspec-rails"
  gem "fakeweb"
  gem "spork"
  gem "parallel_tests"
  gem "shoulda-matchers"
  gem "timecop"
  gem "webmock"
end

group :test, :development do
  gem "factory_girl_rails"
#  gem "ruby-debug"
  gem 'ruby-debug19', :require => 'ruby-debug'
end
