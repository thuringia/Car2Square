require 'sinatra'
require 'httparty'
require 'json'
require 'rack/ssl'

class App < Sinatra::Base

#Configuration
  use Rack::SSL

  configure :production, :development do
    enable :logging
  end

#Foursquare API Data
  client_id = "OMN4ZDLH4MUKFLAZ2FFDQ2M2ANQSIQPR2SAOMRF23QZNYSVE"
  client_secret = "GMKLL4DICI0EBDFZFZ1Z0H4B2TOWCNMXWEBIFLXZFHGIMC50"

  push_secret = 'PNWOQIAM3P3E1WRQM0FV3TE5S0ZLR4AXISPOETXNZDKHPBON'

  redirect_url = "http://car2square.herokuapp.com/4sq"

  auth_url = "https://foursquare.com/oauth2/authenticate?client_id="
  auth_url.concat(client_id)
  auth_url.concat("&response_type=code&redirect_uri=")
  auth_url.concat(redirect_url)

  token_url = "https://foursquare.com/oauth2/access_token?client_id="
  token_url.concat(client_id)
  token_url.concat("&client_secret=")
  token_url.concat(client_secret)
  token_url.concat("&grant_type=authorization_code&redirect_uri=")
  token_url.concat(redirect_url)
  token_url.concat("&code=")

#Car2Go API data


#Car2Go locations
  locations=['amsterdam', 'austin', 'berlin', 'birmingham', 'calgary', 'dusseldorf', 'hamburg', 'cologne', 'london', 'miami',
             'portland', 'san diego', 'seattle', 'stuttgart', 'toronto', 'ulm', 'vancouver', 'dc', 'vienna']

  get '/foursquare/auth' do
    redirect to(auth_url)
  end

  get '/foursquare/callback/:code' do
    code = params[:code]
    fsq_token = JSON.parse(HTTParty.get(@@token_url + code)).values_at('access_token')[0]
  end

  post '/foursquare/push' do
    puts request.body

    if params[:secret].eql?(push_secret)
      checkin_obj = JSON.parse(params[:checkin])
      id = checkin_obj['id']
      logger.info id
      HTTParty.post('https://api.foursquare.com/v2/checkins/'+id+'/reply?text=DEBUG')
    end
  end
end
