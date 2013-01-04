class FoursquareController < ApplicationController

  @@client_id = "OMN4ZDLH4MUKFLAZ2FFDQ2M2ANQSIQPR2SAOMRF23QZNYSVE"
  @@client_secret = "GMKLL4DICI0EBDFZFZ1Z0H4B2TOWCNMXWEBIFLXZFHGIMC50"

  @@push_secret = 'PNWOQIAM3P3E1WRQM0FV3TE5S0ZLR4AXISPOETXNZDKHPBON'

  @@redirect_url = "http://car2square.herokuapp.com/4sq"

  @@auth_url = "https://foursquare.com/oauth2/authenticate?client_id="
  @@auth_url.concat(@@client_id)
  @@auth_url.concat("&response_type=code&redirect_uri=")
  @@auth_url.concat(@@redirect_url)

  @@token_url = "https://foursquare.com/oauth2/access_token?client_id="
  @@token_url.concat(@@client_id)
  @@token_url.concat("&client_secret=")
  @@token_url.concat(@@client_secret)
  @@token_url.concat("&grant_type=authorization_code&redirect_uri=")
  @@token_url.concat(@@redirect_url)
  @@token_url.concat("&code=")

  def auth
    redirect_to @@auth_url
  end

  def callback(code)
    code = code
    puts(JSON.parse(HTTParty.get(@@token_url + code)).values_at("access_token")[0])

    #usr = new User(:fsq_token => JSON.parse(HTTParty.get(@@token_url + code)).values_at("access_token")[0])

    #redirect_to :controller => Car2goController, :action => :auth, :usr => usr if usr.save
  end

  def push(checkin,secret)
    if secret.eql?(@@push_secret)
      checkin_obj = JSON.parse(checkin)
      HTTParty.post('https://api.foursquare.com/v2/checkins/'+checkin['id']+'/reply?text=DEBUG')
    end
  end
end