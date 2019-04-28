class ApplicationController < ActionController::Base
  helper_method :logged_in?
  def current_user
    @user ||= User.find(session[:user_id]) if logged_in?
  end

  def logged_in?
    session[:user_id].present?
  end

  def require_same_user
    if logged_in? && params[:id].to_i != current_user.id
      flash[:alert] = 'unauthorized action, you can only see and modify the data of youself'
      redirect_to user_path(current_user)
    end
  end
end
