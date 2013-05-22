require './database'

class FSUser < Sequel::Model
  attr_reader :f_id, :name, :f_token, :c_id, :c_token

  FSUser.plugin :timestamps, :created=>:created_on, :updated=>:updated_on

  def init_data(json, token)
    obj = JSON.parse(json)

    @f_id = obj[:id]
    @name = obj[:firstName]
    @f_token = token
  end
end