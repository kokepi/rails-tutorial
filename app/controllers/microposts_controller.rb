class MicropostsController < ApplicationController
  before_filter :authenticate

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
    
  end

end
