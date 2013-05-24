require 'sinatra'
require 'httparty'
require 'json'
require 'rack/ssl'
require './database'
require './foursquare/user'
require './foursquare/checkin'
require './car2go/locations'
require './car2go/car'

class App < Sinatra::Base

#Configuration
  use Rack::SSL

  set :haml, :format => :html5
  enable :sessions

  configure :production, :development do
    enable :logging
  end

#Foursquare API Data
  client_id = 'OMN4ZDLH4MUKFLAZ2FFDQ2M2ANQSIQPR2SAOMRF23QZNYSVE'
  client_secret = 'GMKLL4DICI0EBDFZFZ1Z0H4B2TOWCNMXWEBIFLXZFHGIMC50'

  push_secret = 'PNWOQIAM3P3E1WRQM0FV3TE5S0ZLR4AXISPOETXNZDKHPBON'

  redirect_url = 'http://car2square.herokuapp.com/foursquare/callback'

  auth_url = 'https://foursquare.com/oauth2/authenticate?client_id='
  auth_url.concat(client_id)
  auth_url.concat('&response_type=code&redirect_uri=')
  auth_url.concat(redirect_url)

  token_url = 'https://foursquare.com/oauth2/access_token?client_id='
  token_url.concat(client_id)
  token_url.concat('&client_secret=')
  token_url.concat(client_secret)
  token_url.concat('&grant_type=authorization_code&redirect_uri=')
  token_url.concat(redirect_url)
  token_url.concat('&code=')

  # load the car2go locations on startup
  Location.load_locations

  get '/foursquare/auth' do
    redirect to(auth_url)
  end

  get '/foursquare/callback' do
    # store CODE so we can request the OAuth token
    code = params[:code]
    logger.info code

    # get the OAuth token
    logger.info (token_url + code)

    response = HTTParty.get(token_url + code)

    obj = JSON.parse(response.body)
    logger.info obj

    fsq_token = response['access_token']
    logger.info "foursquare token: #{fsq_token}"

    # get user data
    url = ("https://api.foursquare.com/v2/users/self/?oauth_token=" + fsq_token)
    logger.info "requesting: #{url}"

    user = FSUser.new

    user_obj = JSON.parse(HTTParty.get(url).body)

    user.f_id     = user_obj['response']['user']['id']
    user.name     = user_obj['response']['user']['firstName']
    user.f_token  = fsq_token

    logger.info "user data: #{user.values}"

    user.save

    #show a message
    haml :callback
  end

  ##
  # Handle the foursquare push
  post '/foursquare/push' do
    logger.info "push received"
    status 200

    # check if the request is really from foursquare
    if params[:secret].eql?(push_secret)

      # parse the checkin json and get the checkin_id and user_id
      checkin = Checkin.new(params[:checkin])
      logger.info checkin

      # check if the check-in's city is in a C2G area
      logger.info Location.available?(checkin.ll)

      car2go_city = Location.available?(checkin.ll)
      if car2go_city.eql?('')
        return 200
      end

      logger.info 'check-in in C2G area'

      # check if there are cars available
      vehicles = Car.load_cars(car2go_city)

      if vehicles.empty?
        return 200
      end

      logger.info 'cars available'

      vehicles.each do |v|
        v.distance = v.calculate_distance(checkin.ll)
      end

      vehicles.sort_by! {|a| a.distance}

      logger.info "closest car #{vehicles[0].distance}"
      return 200 unless vehicles[0].distance < 0.5

      user = FSUser[checkin.u_id]
      logger.info user

      msg = "Hey #{user.name}, #{vehicles[0].name} is #{vehicles[0].distance}km away from you at #{vehicles[0].address}"
      logger.info msg

      # build the url and request
      url = 'https://api.foursquare.com/v2/checkins/'+c_id+'/reply'
      options = {
          :body => {
              :text => msg},
          :headers => {
              "oauth-token" => user[:f_token]
          }
      }
      response = HTTParty.post(url, options)
      logger.info response
    end
  end

  get '/privacy' do
    haml :privacy
  end

end
