require './database'

class FSUser < Sequel::Model

  FSUser.plugin :timestamps, :created=>:created_on, :updated=>:updated_on

end