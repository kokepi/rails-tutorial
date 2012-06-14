class UsersController < ApplicationController
  before_filter :authenticate, :only => [ :edit,:update,:index ]
  before_filter :owner_only, :only => [ :edit,:update ]

  def new
    @user = User.new
    @title = 'Sign up'
  end

  def show
    @user = User.find(params[:id])
    @title = 'User: ' + @user.name
  end

  def index
    @title = "All users"
    @users = User.all
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

  private

  def authenticate
    deny_access unless signed_in?
  end
  def owner_only
    @user = User.find(params[:id])
    if current_user?(@user)
      @owner = @user
    else
      redirect_to(root_path, :notice => "You can't access that page. The action was logged for security.") 
    end
  end


end
