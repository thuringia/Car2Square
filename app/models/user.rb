class User < ActiveRecord::Base
  attr_accessible :fsq_token, :c2g_token
end
