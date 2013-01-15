require 'sinatra'
require 'httparty'
require 'json'
require 'rack/ssl'
require 'database'
require 'foursquare/user'
require 'foursquare/checkin'
require 'car2go/locations'
require 'car2go/car'

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

  # have car2go locations ready
  locations = Locations.new

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
    user.safe
  end

  ##
  # Handle the foursquare push
  post '/foursquare/push' do
    # check if the request is really from foursquare
    if params[:secret].eql?(push_secret)

      # parse the checkin json and get the checkin_id and user_id
      checkin = Checkin.new(params[:checkin])

      # check if the check-in's city is in a C2G area
      return unless locations.available?(checkin.city)

      # check if there are cars available
      vehicles = Car.free?(checkin.city)

      return unless !vehicles.empty?

      cars = []
      vehicles.each do |v|
        tmpCar = new Car(v)
        tmpCar.distance(checkin ll)
        cars.push(tmpCar)
      end

      cars.sort_by! {|a| a[:distance]}

      return unless cars[0].distance < 0.5

      user = database[:users => u_id]
      msg = "Hey #{user[:username]}, #{cars[0].name} is #{cars[0].distance}km away from you at #{cars[0].address}"

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
end
