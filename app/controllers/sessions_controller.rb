class SessionsController < ApplicationController
  def new
    redirect_to user_path(current_user) if logged_in?
  end
  
  def create
    user = User.find_by(email: params[:email])
    if user && user.bcrypt_password == params[:password]
      flash[:success] = 'login succeeded'
      session[:user_id] = user.id
      redirect_to user_path(user)
    else
      flash[:alert] = 'login failed'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
