class ApplicationController < ActionController::Base
  include Exceptions
  protect_from_forgery

  def user_color
    session[:color] ||= Color::HSL.new(rand(359), 60, 60).to_rgb.html
  end
end
