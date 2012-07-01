require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email,
    :name,
    :password,
    :password_confirmation
  has_many :microposts,
    :dependent => :destroy
  has_many :user_relationships,
    :foreign_key => "follower_id",
    :dependent => :destroy
  has_many :followings,
    :through => :user_relationships,
    :source => :followed
  has_many :reverse_user_relationships,
    :foreign_key => "followed_id",
    :class_name => "UserRelationship",
    :dependent => :destroy
  has_many :followers,
    :through => :reverse_user_relationships,
    :source => :follower
  email_regex = /^[\w+\-\.]+@[a-z\d\-.]+\.[a-z]+$/i

  # これが単純なモデルと振る舞いを変えている
  before_save :encrypt_password

  validates :name,
    :presence => true,
    :length => { :maximum => 50, :minimum => 2 }
  validates :email,
    :presence => true,
    :format => { :with => email_regex },
    :uniqueness => { :case_sensitive => false }
  validates :password,
    :presence => true,
    :confirmation => true,
    :length => { :within => 2..50 }

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = User.find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def feed
    Micropost.where("user_id = ?", id)
  end

  def following?(followed)
    user_relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    user_relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    user_relationships.find_by_followed_id(followed).destroy
  end

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

end
