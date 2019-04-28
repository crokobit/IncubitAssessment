class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'user created'
      redirect_to user_path(@user)
    else
      flash[:alert] = 'user is not created'
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
      flash[:alert] = 'failed'
      render :edit
    end
  end
  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
  
  def update_user_params
    params.require(:user).permit(:username, :password)
  end
end
