require 'spec_helper'


describe 'Users' do
  describe 'signup' do
    describe 'failure' do
      it "should have error messages" do
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
      it "should have error messages" do
        lambda do
          visit signup_path
          fill_in "Name", :with => "test user"
          fill_in "Email", :with => "test_user@example.com"
          fill_in "Password", :with => "foobar"
          fill_in "Password confirmation", :with => "foobar"
          click_button
          response.should render_template('users/show')
          response.should have_selector("div.flash.success")
        end.should change(User, :count).by(1)
      end
    end
  end
end


