require 'spec_helper'

describe User do

  before(:each) do
    @attr = {:name => 'testuser', :email => "testuser@example.com"}
  end

  it "should create a new instance given valid attribute" do
    User.create(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  context "email format" do

    it "should have valid email format" do
      a = %w[user@example.com USER_EMAIL@example.com first.last@example.jp]
      a.each do |t|
        valid_email_user = User.new(@attr.merge(:email => t))
        valid_email_user.should be_valid
      end
    end

    it "should reject invalid email format" do
      a = %w[user@example,com USER_EMAIL_et_example.com first.last@example.]
      a.each do |t|
        invalid_email_user = User.new(@attr.merge(:email => t))
        invalid_email_user.should_not be_valid
      end
    end

  end

  it "should reject duplicate email address" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end


end
