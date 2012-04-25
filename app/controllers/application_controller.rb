class ApplicationController < ActionController::Base
  include Exceptions
  protect_from_forgery
end
