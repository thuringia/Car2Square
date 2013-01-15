require 'sinatra'
require 'httparty'
require 'json'
require 'rack/ssl'
require './database'
require 'foursquare/user'

class App < Sinatra::Base

#Configuration
  use Rack::SSL

  set :haml, :format => :html5
  enable :sessions

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

  get '/foursquare/callback/' do
    # store CODE so we can request the OAuth token
    code = params[:code]

    # get the OAuth token
    fsq_token = JSON.parse(HTTParty.get(token_url + code)).values_at('access_token')[0]

    # get user data
    url = ("https://api.foursquare.com/v2/users/self/?oauth_token=" + fsq_token)
    user = FSUser.new(HTTParty.get(url), fsq_token)
    session[:f_id] = user.id

    # redirect to Car2Go auth
    redirect to()
  end

  ##
  # Handle the foursquare push
  post '/foursquare/push' do
    # check if the request is really from foursquare
    if params[:secret].eql?(push_secret)

      # parse the checkin json and get the id
      checkin_obj = JSON.parse(params[:checkin])
      id = checkin_obj[:id].to_s

      # build the url and request
      url = 'https://api.foursquare.com/v2/checkins/'+id+'/reply'
      options = {
          :body => {
              :text => 'DEBUG'},
          :headers => {
              "oauth-token" => database[:users => session[:f_id]][:f_token]
          }
      }
      response = HTTParty.post(url, options)
      logger.info response
    end
  end
end
