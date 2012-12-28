source :rubygems
source :rubyforge

gem 'rails', '3.2.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem "jquery-rails"
gem 'pry'
gem 'ruby-graphviz'
gem 'color'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem "rspec-rails"
  gem "spork"
  gem "shoulda-matchers"
  gem "webmock"
  gem 'rb-inotify', '~> 0.8.8'
  gem "factory_girl_rails"
end

group :test, :development do
  gem "guard"
  gem "guard-spork"
  gem "guard-rspec"
 # gem 'linecache19', '>= 0.5.13'
  gem 'ruby-debug-base19x', '>= 0.11.30.pre10'
  gem 'ruby-debug-ide', '>= 0.4.17.beta14'
  gem 'ruby-debug19'
end
