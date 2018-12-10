class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user &.authenticate(params[:session][:password])
      log_in user
      check_remember user
      redirect_back_or user
    else
      flash.now[:danger] = t "users.create.invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def check_remember user
    params[:session][:remember_me] == Settings.remmenber_1 ? remember(user) : forget(user)
  end
end
