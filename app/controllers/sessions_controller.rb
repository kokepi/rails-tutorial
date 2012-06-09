class SessionsController < ApplicationController

  def new
    @title = 'Sign in'
  end
  def create
    @user = User.authenticate(params[:session][:email], params[:session][:password])
    if @user.nil?
      flash.now[:error] = "Email and Password don't match."
      render 'new'
    else
      sign_in @user 
      flash[:success] = "Thank you for visit again."
      redirect_to @user
    end
    
  end
  def destroy
    sign_out
    flash[:success] = "Logged out from the app. Thank you."
    redirect_to root_path
  end
end
