class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "success"
      redirect_to @user
    else
      render :new
    end
  end
  
  def show; end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "users.update.update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.destroy.destroy_success"
      redirect_to users_path
    else
      flash[:danger]  = t "users.destroy.destroy_fail."
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "users.load_user_danger"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "users.logged_in_user.danger_login"
    redirect_to login_path
  end

  def correct_user
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
