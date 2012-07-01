require 'spec_helper'

describe MicropostsController do
  render_views

  describe 'access control' do
    it 'should deny access to "create"' do
      post :create
      response.should redirect_to(signin_path)
    end
    it 'should deny access to "destroy"' do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe 'POST "create"' do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe 'failure' do
      before(:each) do
        @attr = { :content => ""}
      end
      it 'should not create a mp' do
        lambda do 
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end
      it 'should have a flash error message' do
        post :create, :micropost => @attr
        flash[:error].should_not be_blank
      end
      it 'should redirect_to home' do
        post :create, :micropost => @attr
        response.should redirect_to root_path
      end
    end
    describe 'success' do
      before(:each) do
        @attr = { :content => "Lorem ipsum" }
      end
      it 'should create a mp' do
        lambda do 
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end
      it 'should have a flash message' do
        post :create, :micropost => @attr
        flash[:success].should_not be_blank
      end
      it 'should redirect_to home' do
        post :create, :micropost => @attr
        response.should redirect_to root_path
      end
    end

  end

  describe 'DELETE "destroy"' do
    describe 'for un-authorized user' do
      before(:each) do
        @user = Factory(:user)
        @wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(@wrong_user)
        @mp = Factory(:micropost, :user => @user)
      end
      it 'should deny access' do
        delete :destroy, :id => @mp
        response.should redirect_to root_path
      end
    end
    describe 'for authorized user' do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @mp = Factory(:micropost, :user => @user)
      end
      it 'should destroy the micropot' do
        lambda do
          delete :destroy, :id => @mp
        end.should change(Micropost, :count).by(-1)
      end
      it 'should redirect_to root' do
        delete :destroy, :id => @mp
        response.should redirect_to root_path
      end
      it 'should have a flash message' do
        delete :destroy, :id => @mp
        flash[:success].should_not be_blank
      end
    end
  end

end
