require 'database'

class FSUser
  attr_reader :id, :name, :token

  def initialize(json, token)
    obj = JSON.parse(json)

    @id = obj[:id]
    @name = obj[:firstName]
    @token = token
  end

  ##
  # Persist the instance to the database
  def safe
    users = database[:users]
    users.insert[:username => @name, :f_id => @id, :f_token => @token]


  end
end