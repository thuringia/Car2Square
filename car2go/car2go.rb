require 'httparty'

class Car2go
  @@consumer_key = "Car2Square"
  @@secret = "tZxa8ts1KFsjyyirNfEX"
  @@base_uri = "http://www.car2go.com/api/v2.1/"
  @@req_params = "?oauth_consumer_key=#{@@consumer_key}&format=json"

  def self.getRes(resource, params)
    response = HTTParty.get((@@base_uri + resource + @@req_params + params))
    return response
  end
end