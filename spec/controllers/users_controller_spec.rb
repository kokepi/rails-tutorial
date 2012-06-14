require 'spec_helper'

describe UsersController do
  render_views

  describe 'GET "index"' do
    describe 'for non-signin users' do
      it 'should deny access' do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end
    describe 'for signed-in users' do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second_user = Factory(:user, :email => "another@example.com")
        third_user = Factory(:user, :email => "other@example.com")
        @users = [@user, second_user, third_user]
      end
      it 'should be successful' do
        get :index
        response.should be_success
      end
      it 'should have an elem for each user' do
        get :index
        @users.each do |user| 
          response.should have_selector("li", :content => user.name)
        end
      end

    end
  end
  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end
    it "should be 200" do
      get :show, :id => @user
      response.should be_success
    end
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => 'Sign up')
    end
  end

  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => ""}
      end
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector('title', :content => "Sign up")
      end
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    describe 'success' do
      before(:each) do
        @attr = { :name => "test user", :email => "test@example.com", :password => "test-pass", :password_confirmation => "test-pass"}
      end
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      it "should redirect_to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      it "should signed in the user" do
        post :create, :user => @attr
        controller.signed_in?.should be_true
      end
    end
  end

  describe 'GET "edit"' do
  
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it 'should be successful' do
      get :edit, :id => @user
      response.should be_success
    end
    it 'should have the right title' do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit")
    end
    it 'should have a link to change gravatar' do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url)
    end 
    
  end

  describe 'PUT "update"' do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe 'failure' do

      before(:each) do
        @attr = { :email => "", :name => "" }
      end
      
     it 'should render the edit page' do
       put :update, :id => @user, :user => @attr
       response.should render_template('edit')
     end 

     it 'should have the right title' do
       put :update, :id => @user, :user => @attr
       response.should have_selector("title", :content => "Edit user")
     end

    end

    describe 'success' do
      
      before(:each) do
        @attr = { :name => "New name", :email => "user@example.org", :password => "pass", :password_confirmation => "pass" }

      end

      it "should change the user's attributes" do
       put :update, :id => @user, :user => @attr
       @user.reload
       @user.name.should == @attr[:name]
       @user.email.should ==  @attr[:email]
      end

      it "should redirect_to the user show page" do
       put :update, :id => @user, :user => @attr
       response.should redirect_to(user_path(@user))
      end

      it "should have a flash alert-success message" do
       put :update, :id => @user, :user => @attr
       flash[:success].should_not be_nil
      end

    end
  end

  describe 'authentication of edit pages' do
    before(:each) do
      @user = Factory(:user)
    end

    describe 'for non-signed-in users' do
      it "should deny access to edit page" do
        get :edit, :id => @user, :user => ()
        response.should redirect_to(signin_path)
      end
      it "should deny access to update" do
        put :update, :id => @user, :user => ()
        response.should redirect_to(signin_path)
      end
    end

    describe 'for signed in users' do
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      it 'should require matching users for "edit"' do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
      it 'should require matching users for "update"' do
        put :update, :id => @user, :user => ()
        response.should redirect_to(root_path)
      end
    end

  end

end
