require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] = "test"
  require File.expand_path("../../config/environment", __FILE__)
  Dir[Rails.root.join("spec/support/*.rb")].each { |f| require f }
  require 'rspec/rails'
  RSpec.configure do |config|
    # Use color in STDOUT
    config.color_enabled = true
    # Use color not only in STDOUT but also in pagers and files
    config.tty = true
    # Use the specified formatter
    config.formatter = :documentation # :progress, :html, :textmate
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.filter_run_excluding :wip => true
    config.run_all_when_everything_filtered = true
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

  # Hack to ensure models get reloaded by Spork - remove as soon as this is fixed in Spork.
  # Silence warnings to avoid all the 'warning: already initialized constant' messages that
  # appear for constants defined in the models.
  silence_warnings do
    Dir["#{Rails.root}/app/models/**/*.rb"].each { |f| load f }
  end
end
