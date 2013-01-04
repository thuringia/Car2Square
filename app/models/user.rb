class User < ActiveRecord::Base
  attr_accessible :fsq_token

  has_one  :car2go, :class_name => "Car2GoToken", :dependent => :destroy
end
