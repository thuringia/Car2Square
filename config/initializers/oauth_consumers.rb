# edit this file to contain credentials for the OAuth services you support.
# each entry needs a corresponding token model.
#
# eg. :twitter => TwitterToken, :hour_feed => HourFeedToken etc.
#
OAUTH_CREDENTIALS={
    :car2go => {
        :key => "Car2Square",
        :secret => 'tZxa8ts1KFsjyyirNfEX',
        :request_token_path => 'https://www.car2go.com/api/reqtoken',
        :access_token_path => 'https://www.car2go.com/api/accesstoken',
        :authorize_path => 'https://www.car2go.com/api/authorize'
    }
}
#
OAUTH_CREDENTIALS={
} unless defined? OAUTH_CREDENTIALS

load 'oauth/models/consumers/service_loader.rb'