class UsersController < ApplicationController
  before_action :require_same_user, only: [:show, :edit, :update]
  before_action :require_logged_in, only: [:show, :edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      WelcomeMailer.welcome_mail(@user).deliver_now
      flash[:success] = 'user created'
      redirect_to login_path 
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(update_user_params)
      flash[:success] = 'user updated'
      redirect_to user_path(@user)
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
  def update_user_params
    user = params.require(:user).permit(:username, :password, :password_confirmation)

    if user[:password].empty? && user[:password_confirmation].empty?
      user.delete(:password) 
      user.delete(:password_confirmation) 
    end

    user
  end
end
