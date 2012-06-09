require 'spec_helper'


describe 'Users' do

  describe 'signup' do

    describe 'failure' do
      it "should have error messages and do not increase the numbers of users" do
        lambda do
          visit signup_path
          fill_in "Name", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe 'success' do
      it "should increase the numbers of users" do
        lambda do
          visit signup_path
          fill_in "Name", :with => "test user"
          fill_in "Email", :with => "test_user@example.com"
          fill_in "Password", :with => "foobar"
          fill_in "Password confirmation", :with => "foobar"
          click_button
          response.should render_template('users/show')
          response.should have_selector("div.flash.alert-success")
        end.should change(User, :count).by(1)
      end
    end
  end

  describe 'sign in' do

    describe 'failure' do
      it "should have error messages" do
        visit signin_path
        fill_in :email, :with => "test_user@example.com"
        fill_in :password, :with => "foobar"
        click_button
        response.should have_selector("div.flash.alert-error")
      end
    end

    describe 'success' do
      it "should sign a user in and out" do
        user = Factory(:user)
        visit signin_path
        fill_in :email, :with => user.email
        fill_in :password, :with => user.password
        click_button
        controller.should be_signed_in
        response.should render_template('users/show')
        click_link "Logout"
        controller.should_not be_signed_in
      end

    end
  end

end


