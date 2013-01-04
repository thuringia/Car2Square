class FoursquareController < ApplicationController

  @@client_id = "OMN4ZDLH4MUKFLAZ2FFDQ2M2ANQSIQPR2SAOMRF23QZNYSVE"
  @@client_secret = "GMKLL4DICI0EBDFZFZ1Z0H4B2TOWCNMXWEBIFLXZFHGIMC50"

  @@redirect_url = "http://car2square.herokuapp.com/4sq"
  @@auth_url = "https://foursquare.com/oauth2/authenticate?client_id="+@@client_id
  +"&response_type=code&redirect_uri="+@@redirect_url

  @@token_url = "https://foursquare.com/oauth2/access_token?client_id="+@@client_id
  +"&client_secret="+@@client_secret
  +"&grant_type=authorization_code&redirect_uri="+@@redirect_url
  +"&code="+@code

  def auth
    redirect_to @@auth_url
  end

  def callback(code)
    @code = code
    @usr = new User(:fsq_token => JSON.parse(HTTParty.get(@@token_url)).values_at("access_token")[0])

    redirect_to :controller => Car2goController, :action => :auth, :fsq_token => @usr.fsq_token if @usr.save
  end

  def push
    
  end
end