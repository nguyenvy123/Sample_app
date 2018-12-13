class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = t "micropost.create"
      redirect_to root_path
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
  	if @micropost.destroy
      flash[:success] = t "micropost.delete"
      redirect_to request.referrer || root_path
    else
      flash[:danger] = t "micropost.nodelete"
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_path unless @micropost
  end
end
