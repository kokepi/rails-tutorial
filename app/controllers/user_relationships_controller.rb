class UserRelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:user_relationship][:followed_id])
    current_user.follow!(@user)
    redirect_to @user
  end

  def destroy
    @user = UserRelationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to @user
  end
end
