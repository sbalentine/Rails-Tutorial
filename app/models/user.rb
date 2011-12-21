class User < ActiveRecord::Base
  
  # only name and email attributes can be changed
  
  attr_accessible :name, :email
  
  # regex for recognizing email patterns
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # rule for presence and length
  
  validates :name, :presence => true, 
                   :length => {:maximum => 50}
  
  # rule for presence, format, uniqueness, and case-sensitivity
  
  validates :email, :presence => true, 
                    :format => {:with => email_regex},
                    :uniqueness => {:case_sensitive => false}
  
end
