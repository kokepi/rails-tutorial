class PagesController < ApplicationController

  def home
    @title = 'Home'
    @desc = 'This is the home page for sample app'
    if signed_in?
      @micropost = Micropost.new
      @microposts = current_user.microposts.paginate(:page => params[:page])
    end
  end

  def contact
    @title = 'Contact'
    @desc = 'This is the contact page for sample app'
  end

  def about
    @title = 'About'
    @desc = 'This is the about page for sample app'
  end
  
  def help
    @title = 'Help'
    @desc = 'This is the help  page for sample app'
  end


end
