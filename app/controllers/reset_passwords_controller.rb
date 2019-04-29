class ResetPasswordsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:email])

    if @user
      send_reset_password_email
    else
      flash[:alert] = "can't find this email" 
    end
    render :new
  end

  def edit
    @user = User.find_by(reset_digest: params[:id])

    if @user && @user.has_valid_reset_digest?
      render :edit
    else
      flash[:alert] = 'invalid link'
      redirect_to login_path
    end
  end

  def do_password_reset
    @user = User.find_by(reset_digest: params[:id])
    if @user.has_valid_reset_digest? && @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      @user.clear_reset_password_variables
      flash[:success] = 'reset password success'

      redirect_to login_path
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :edit
    end
  end

  private
  def send_reset_password_email
    @user.set_reset_password_variables
    url = edit_reset_password_url(@user.reset_digest)
    ResetPasswordMailer.reset_password_link(@user, url).deliver_now
  end
end
