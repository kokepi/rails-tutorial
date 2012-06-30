class UsersController < ApplicationController
  before_filter :authenticate, :only => [ :edit,:update,:index,:destroy ]
  before_filter :owner_only, :only => [ :edit,:update ]
  before_filter :admin_only, :only => :destroy

  def new
    @user = User.new
    @title = 'Sign up'
  end

  def show
    @user = User.find(params[:id])
    @title = 'User: ' + @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Thank you for sign up!"
      sign_in @user
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit user: " + @user.name
  end
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit user: " + @user.name
      flash[:error] = "Something wrong. Try again."
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "The user deleted."
    redirect_to users_path
  end


  private

  def owner_only
    @user = User.find(params[:id])
    if current_user?(@user)
      @owner = @user
    else
      redirect_to(root_path, :notice => "You can't access that page. The action was logged for security.") 
    end
  end
  def admin_only
    redirect_to(root_path) unless current_user.admin?
  end

end
