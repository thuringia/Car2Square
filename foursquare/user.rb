require './database'

class FSUser < Sequel::Model
  attr_reader :id, :name, :token

  FSUser.plugin :timestamps, :created=>:created_on, :updated=>:updated_on

  def init_data(json, token)
    obj = JSON.parse(json)

    @id = obj[:id]
    @name = obj[:firstName]
    @token = token
  end
end