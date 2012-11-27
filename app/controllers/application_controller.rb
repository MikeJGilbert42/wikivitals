class ApplicationController < ActionController::Base
  include Exceptions
  protect_from_forgery

  before_filter :get_current_user

  def get_current_user
    @user ||= current_user
  end

  def current_user
    if cookies.signed[:user_id]
      User.find(cookies.signed[:user_id])
    else
      user = User.create
      cookies.signed[:user_id] = user.id
      user
    end
  end
end
