require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe 'POST "create"' do

    describe 'widh invalid email and password' do

      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should_not render_template('user/show')
        response.should render_template('new')
      end

      it "should have a flash-error message" do
        post :create, :session => @attr
        response.should have_selector("div.flash.alert-error")
      end

    end

    describe 'with valid email and password' do

      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should be current_user == @user" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.signed_in?.should be_true
      end

      it "should redirect_to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash-success message" do
        post :create, :session => @attr
        flash[:success].should_not be_nil
      end

    end
  end
end
