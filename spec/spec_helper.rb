ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
Dir[Rails.root.join("spec/support/*.rb")].each { |f| require f }
require 'rspec/rails'
