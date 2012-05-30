class User < ActiveRecord::Base
  attr_accessible :email, :name
  email_regex = /^[\w+\-\.]+@[a-z\d\-.]+\.[a-z]+$/i

  validates :name,
    :presence => true,
    :length => { :maximum => 50, :minimum => 2 }
  validates :email,
    :presence => true,
    :format => { :with => email_regex },
    :uniqueness => { :case_sensitive => false }
end
