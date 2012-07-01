class MicropostsController < ApplicationController
  before_filter :authenticate
  before_filter :owner_only, :only => [:destroy]

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Tweeted."
      redirect_to root_path
    else
      flash[:error] = "Can't save."
      redirect_to root_path
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Deleted your post"
    redirect_back_or root_path
  end

  private

  def owner_only
    @micropost = Micropost.find(params[:id])
    redirect_to root_path unless current_user?(@micropost.user)
  end




end
