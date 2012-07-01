require 'spec_helper'

describe UserRelationship do

  before(:each) do
    @follower = Factory(:user)
    @followed = Factory(:user, :email => Factory.next(:email))
    @rel = @follower.user_relationships.build(:followed_id => @followed.id)
  end

  it 'should create user relationships' do
    @rel.save!
  end

  describe 'follow methods' do
    before(:each) do
      @rel.save
    end
    it 'should have a follower attribute' do
      @rel.should respond_to(:follower)
    end
    it 'should have the right follower' do
      @rel.follower.should == @follower
    end
    it 'should have a followed attribute' do
      @rel.should respond_to(:followed)
    end
    it 'should have the right followed' do
      @rel.followed.should == @followed
    end
  end

  describe 'validations' do
    it 'should require a follower_id' do
      @rel.follower_id = nil
      @rel.should_not be_valid
    end
    it 'should require a followed_id' do
      @rel.followed_id = nil
      @rel.should_not be_valid
    end
  end

end
