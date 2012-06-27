require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => 'testuser',
      :email => "testuser@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"

    }
  end

  it "should create a new instance given valid attribute" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end


  describe "email validatons" do

    it "should accept valid email format" do
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

    it "should reject duplicate email address" do
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end

  end


  describe "password validatons" do

    it "should require a password" do
      no_pw_user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
      no_pw_user.should_not be_valid
    end

    it "should require a matching password confirmation" do
      no_pw_match_user = User.new(@attr.merge(:password => "aaaa", :password_confirmation => "not aaaa"))
      no_pw_match_user.should_not be_valid
    end

    it "should reject short password" do
      short_pw_user = User.new(@attr.merge(:password => "a", :password_confirmation => "a"))
      short_pw_user.should_not be_valid
    end

    it "should reject long password" do
      long_pw = "a" * 51
      long_pw_user = User.new(@attr.merge(:password => long_pw, :password_confirmation => long_pw))
      long_pw_user.should_not be_valid
    end

  end
  describe "password encryption" do
    before(:each) do
      @user = User.create(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should have an encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords do not match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do

      it "should return nil when email/password do not match" do
        dont_match_user = User.authenticate(@attr[:email], "wrong password")
        dont_match_user.should be_nil
      end

      it "should return nil when you can not find the user by email" do
        nonexistent_user = User.authenticate("nonexistent_email@example.com", @attr[:passwordr])
        nonexistent_user.should be_nil
      end

      it "should return the user object when email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user == @user
      end

    end

  end

  describe 'admin attribute' do
    before(:each) do
      @user = User.create!(@attr)
    end
    it 'should respond_to :admin' do
      @user.should respond_to(:admin)
    end
    it 'shoud not be an admin by default' do
      @user.should_not be_admin
    end
    it 'shoud be convertible to an admin' do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  describe 'micropost associations' do
    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end
    it 'should have a microposts attribute' do
      @user.should respond_to(:microposts)
    end
    it 'should have the right microposts in the right order' do
      @user.microposts.should == [@mp2, @mp1]
    end
    it 'should destroy associated microposts' do
      @user.destroy
      [@mp1, @mp2].each do |mp|
        Micropost.find_by_id(mp.id).should be_nil
      end

    end
  end

end
