require './database'

class FSUser < Sequel::Model
  attr_reader :f_id, :name, :f_token, :c_id, :c_token, :id
  attr_writer :f_id, :name, :f_token, :c_id, :c_token

  FSUser.plugin :timestamps, :created=>:created_on, :updated=>:updated_on

end