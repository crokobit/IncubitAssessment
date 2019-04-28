class ApplicationController < ActionController::Base
  helper_method :logged_in?
  def current_user
    @user ||= User.find(session[:user_id]) if logged_in?
  end

  def logged_in?
    session[:user_id].present?
  end
end
